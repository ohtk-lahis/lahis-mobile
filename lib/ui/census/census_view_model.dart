import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:podd_app/locator.dart';
import 'package:podd_app/models/animal_species.dart';
import 'package:podd_app/models/census_definition.dart';
import 'package:podd_app/models/village.dart';
import 'package:podd_app/models/village_census.dart';
import 'package:podd_app/services/auth_service.dart';
import 'package:podd_app/services/census_service.dart';
import 'package:podd_app/services/feature_capability_service.dart';
import 'package:stacked/stacked.dart';

class CensusViewModel extends BaseViewModel {
  final IAuthService authService = locator<IAuthService>();
  final ICensusService censusService = locator<ICensusService>();
  final IFeatureCapabilityService featureCapabilityService =
      locator<IFeatureCapabilityService>();

  List<AnimalSpecies> species = [];
  List<CensusKindSummary> censusKinds = [];
  List<CensusSchemaRow> rows = [];
  List<CensusSchemaMeasure> measures = [];
  CensusDefinitionVersion? activeDefinition;
  CensusKindSummary? activeKindSummary;
  VillageCensusSnapshot? latestCensus;
  final measureValues = <String, Map<String, String>>{};
  final _initialMeasureValues = <String, Map<String, String>>{};
  String? message;
  bool usingCachedDefinition = false;
  bool unsupportedSchema = false;
  bool _canSubmitWithLegacyMutation = true;
  final String? requestedKind;
  String? activeKind;
  final Map<String, FocusNode> _inputFocusNodes = {};
  List<String> _visibleInputKeys = const [];

  CensusViewModel({String? kind}) : requestedKind = _normalizeKind(kind) {
    init();
  }

  Village? get selectedVillage => authService.selectedVillage;

  bool get hasCensusAccess =>
      featureCapabilityService.villageEnabled &&
      (authService.userProfile?.hasFeatureEnabled('animal_census_enabled') ??
          false) &&
      selectedVillage != null;

  bool get hasSpecies => species.isNotEmpty;

  bool get hasRows => rows.isNotEmpty;

  bool get canSubmit => hasRows && !unsupportedSchema;

  bool get isHubMode => activeKind == null;

  String get activeKindName =>
      activeKindSummary?.displayName ?? _kindDisplayName(activeKind);

  String? get freshnessLabel {
    if (latestCensus == null) {
      return null;
    }
    return _dateOnly(latestCensus!.censusDate ?? DateTime.now());
  }

  Future<void> init() async {
    setBusy(true);
    message = null;
    clearErrors();
    if (requestedKind == null) {
      _clearLoadedForm();
    }

    if (!hasCensusAccess) {
      setBusy(false);
      return;
    }

    try {
      if (requestedKind != null) {
        await _loadFormForKind(requestedKind!);
      } else {
        await _loadHubOrSingleForm();
      }
    } catch (e) {
      setError(e.toString());
    }

    setBusy(false);
  }

  void setMeasureValue(String rowKey, String measureKey, String value) {
    measureValues.putIfAbsent(rowKey, () => {});
    measureValues[rowKey]![measureKey] = value.trim();
    _clearSubmitError();
    notifyListeners();
  }

  String measureValue(String rowKey, String measureKey) {
    return measureValues[rowKey]?[measureKey] ?? '';
  }

  bool isRowDirty(CensusSchemaRow row) {
    final current = measureValues[row.rowKey] ?? const {};
    final initial = _initialMeasureValues[row.rowKey] ?? const {};
    return measures.any(
      (measure) => (current[measure.key] ?? '') != (initial[measure.key] ?? ''),
    );
  }

  FocusNode focusNodeFor(CensusSchemaRow row, CensusSchemaMeasure measure) {
    final key = _inputKey(row, measure);
    return _inputFocusNodes.putIfAbsent(key, () {
      final node = FocusNode(debugLabel: 'census_$key');
      node.addListener(() {
        if (node.hasFocus) {
          _ensureFocusedInputVisible(node);
        }
      });
      return node;
    });
  }

  TextInputAction textInputActionFor(
    CensusSchemaRow row,
    CensusSchemaMeasure measure,
  ) {
    return _nextInputKeyAfter(_inputKey(row, measure)) == null
        ? TextInputAction.done
        : TextInputAction.next;
  }

  void completeEditing(
    BuildContext context,
    CensusSchemaRow row,
    CensusSchemaMeasure measure,
  ) {
    final key = _inputKey(row, measure);
    final nextKey = _nextInputKeyAfter(key);
    if (nextKey == null) {
      _inputFocusNodes[key]?.unfocus();
      return;
    }

    final nextNode = _inputFocusNodes[nextKey];
    if (nextNode == null) {
      FocusScope.of(context).nextFocus();
      return;
    }
    FocusScope.of(context).requestFocus(nextNode);
    _ensureFocusedInputVisible(nextNode);
  }

  Future<VillageCensusSubmitResult?> submit() async {
    _clearSubmitError();
    message = null;

    if (!hasCensusAccess) {
      setErrorForObject('submit', 'Village census is not available.');
      return null;
    }
    if (unsupportedSchema) {
      setErrorForObject(
        'submit',
        'This census form is not supported by this app version.',
      );
      return null;
    }

    final formData = _buildFormData();
    if (formData == null) {
      notifyListeners();
      return null;
    }

    setBusyForObject('submit', true);
    VillageCensusSubmitResult? result;
    try {
      if (activeDefinition != null) {
        result = await censusService.submitVillageCensusSnapshotV2(
          villageId: selectedVillage!.id,
          definitionVersionId: activeDefinition!.id,
          censusDate: DateTime.now(),
          formData: formData,
        );
        if (result is VillageCensusSubmitUnsupported &&
            _canSubmitWithLegacyMutation) {
          result = await _submitLegacy(formData);
        }
      } else {
        result = await _submitLegacy(formData);
      }
    } catch (e) {
      setErrorForObject('submit', e.toString());
    } finally {
      setBusyForObject('submit', false);
    }

    if (result is VillageCensusSubmitSuccess) {
      latestCensus = result.snapshot;
      _captureInitialValues();
      message = 'Census submitted.';
    } else if (result is VillageCensusSubmitValidationFailure) {
      setErrorForObject('submit', result.messages.join(', '));
    } else if (result is VillageCensusSubmitFailure) {
      setErrorForObject('submit', result.messages.join(', '));
    } else if (result is VillageCensusSubmitUnsupported) {
      setErrorForObject(
        'submit',
        'This census form is not supported by this app version.',
      );
    }

    notifyListeners();
    return result;
  }

  Map<String, dynamic>? _buildFormData() {
    final formRows = <Map<String, dynamic>>[];
    for (final row in rows) {
      final measureMap = <String, int>{};
      for (final measure in measures) {
        final quantity = _parseQuantity(measureValue(row.rowKey, measure.key));
        if (quantity == null) {
          final label = measure.label.isNotEmpty ? measure.label : measure.key;
          setErrorForObject(
            'submit',
            'Enter a non-negative whole number for $label.',
          );
          return null;
        }
        measureMap[measure.key] = quantity;
      }

      final payload = <String, dynamic>{
        'measures': measureMap,
      };
      if (activeKind == 'HUMAN') {
        payload['row_key'] = row.rowKey;
      } else if (row.speciesId != null) {
        payload['species_id'] = row.speciesId;
      } else {
        setErrorForObject(
          'submit',
          'This census form is not supported by this app version.',
        );
        return null;
      }

      formRows.add(payload);
    }
    return {'rows': formRows};
  }

  Future<void> _loadHubOrSingleForm() async {
    censusKinds = await censusService
        .getActiveVillageCensusDefinitions(selectedVillage!.id);
    if (censusKinds.length == 1) {
      await _loadFormForKind(censusKinds.single.kind,
          summary: censusKinds.single);
    } else {
      _clearLoadedForm();
    }
  }

  Future<void> loadKind(String kind) async {
    setBusy(true);
    message = null;
    clearErrors();
    try {
      await _loadFormForKind(kind);
    } catch (e) {
      setError(e.toString());
    }
    setBusy(false);
  }

  Future<void> _loadFormForKind(
    String kind, {
    CensusKindSummary? summary,
  }) async {
    final normalizedKind = _normalizeKind(kind);
    if (normalizedKind == null) {
      throw Exception('Unknown census kind.');
    }

    activeKind = normalizedKind;
    activeKindSummary = summary;
    await _loadCensusRows(normalizedKind, summary: summary);
    if (activeDefinition != null) {
      latestCensus = await censusService.getLatestVillageCensusV2(
        villageId: selectedVillage!.id,
        kind: normalizedKind,
      );
    } else if (normalizedKind == 'ANIMAL') {
      latestCensus =
          await censusService.getLatestVillageCensus(selectedVillage!.id);
    }
    _prefillFromLatestCensus();
  }

  Future<void> _loadCensusRows(
    String kind, {
    CensusKindSummary? summary,
  }) async {
    _canSubmitWithLegacyMutation = true;
    usingCachedDefinition = false;
    unsupportedSchema = false;
    _clearFormData();
    CensusDefinitionVersion? definition;

    if (summary?.activeVersion != null) {
      definition = summary!.activeVersion;
    } else {
      try {
        definition = await censusService.getActiveCensusDefinitionVersion(
          kind: kind,
        );
      } catch (_) {
        definition = await censusService.getCachedCensusDefinitionVersion(
          kind: kind,
        );
        usingCachedDefinition = definition != null;
        if (definition == null) {
          rethrow;
        }
      }
    }

    if (definition == null && kind == 'ANIMAL') {
      species = await censusService.fetchActiveSpecies();
      _useLegacySpeciesRows(species);
    } else if (definition == null) {
      unsupportedSchema = true;
    } else {
      activeDefinition = definition;
      rows = definition.runtimeSchema.rows;
      measures = definition.runtimeSchema.measures;
      if (kind == 'ANIMAL') {
        species = definition.runtimeSchema.toAnimalSpeciesRows();
        unsupportedSchema =
            !definition.runtimeSchema.supportsMobileAnimalSubmit;
        _canSubmitWithLegacyMutation =
            definition.runtimeSchema.supportsLegacyAnimalSubmit;
      } else if (kind == 'HUMAN') {
        unsupportedSchema = !definition.runtimeSchema.supportsMobileHumanSubmit;
        _canSubmitWithLegacyMutation = false;
      } else {
        unsupportedSchema = true;
        _canSubmitWithLegacyMutation = false;
      }
    }

    _ensureValueSlots();
  }

  Future<VillageCensusSubmitResult> _submitLegacy(
    Map<String, dynamic> formData,
  ) {
    final facts = _buildLegacyFacts(formData);
    if (facts == null) {
      return Future.value(
        VillageCensusSubmitValidationFailure([
          'This census form is not supported by this app version.',
        ]),
      );
    }
    return censusService.submitVillageCensusSnapshot(
      villageId: selectedVillage!.id,
      censusDate: DateTime.now(),
      facts: facts,
    );
  }

  List<AnimalCensusFactInput>? _buildLegacyFacts(
    Map<String, dynamic> formData,
  ) {
    final formRows = formData['rows'] as List? ?? const [];
    final facts = <AnimalCensusFactInput>[];
    for (final row in formRows.whereType<Map>()) {
      final measures = Map<String, dynamic>.from(row['measures'] as Map);
      final speciesId = row['species_id'] as int?;
      final animalQuantity = measures['animal_quantity'] as int?;
      final householdQuantity = measures['household_quantity'] as int?;
      if (speciesId == null ||
          animalQuantity == null ||
          householdQuantity == null) {
        return null;
      }
      facts.add(
        AnimalCensusFactInput(
          speciesId: speciesId,
          animalQuantity: animalQuantity,
          householdQuantity: householdQuantity,
        ),
      );
    }
    return facts;
  }

  void _useLegacySpeciesRows(List<AnimalSpecies> speciesRows) {
    activeDefinition = null;
    rows = speciesRows
        .map(
          (item) => CensusSchemaRow(
            rowKey: 'species:${item.id}',
            label: item.name,
            speciesId: item.id,
            speciesCode: item.code,
            sortOrder: item.sortOrder,
          ),
        )
        .toList();
    measures = const [
      CensusSchemaMeasure(
        key: 'animal_quantity',
        label: 'Heads',
        type: 'integer',
        required: true,
      ),
      CensusSchemaMeasure(
        key: 'household_quantity',
        label: 'Households keeping this species',
        type: 'integer',
        required: true,
      ),
    ];
  }

  void _ensureValueSlots() {
    for (final row in rows) {
      measureValues.putIfAbsent(row.rowKey, () => {});
      for (final measure in measures) {
        measureValues[row.rowKey]!.putIfAbsent(measure.key, () => '');
      }
    }
    _syncInputFocusNodes();
    _captureInitialValues();
  }

  void _prefillFromLatestCensus() {
    if (latestCensus == null) {
      _captureInitialValues();
      return;
    }

    final submittedRows = latestCensus!.formData['rows'];
    if (submittedRows is List && submittedRows.isNotEmpty) {
      for (final submittedRow in submittedRows.whereType<Map>()) {
        final rowKey = submittedRow['row_key']?.toString();
        final speciesId = submittedRow['species_id'];
        final row = rows.where((candidate) {
          if (rowKey != null && rowKey.isNotEmpty) {
            return candidate.rowKey == rowKey;
          }
          return candidate.speciesId == speciesId;
        }).firstOrNull;
        if (row == null) {
          continue;
        }

        final submittedMeasures = submittedRow['measures'];
        if (submittedMeasures is! Map) {
          continue;
        }
        measureValues.putIfAbsent(row.rowKey, () => {});
        for (final measure in measures) {
          final value = submittedMeasures[measure.key];
          if (value != null) {
            measureValues[row.rowKey]![measure.key] = value.toString();
          }
        }
      }
      _captureInitialValues();
      return;
    }

    final factsBySpeciesId = {
      for (final fact in latestCensus!.facts) fact.species.id: fact,
    };
    for (final row in rows) {
      final fact = factsBySpeciesId[row.speciesId];
      if (fact == null) {
        continue;
      }
      measureValues.putIfAbsent(row.rowKey, () => {});
      measureValues[row.rowKey]!['animal_quantity'] =
          fact.animalQuantity.toString();
      measureValues[row.rowKey]!['household_quantity'] =
          fact.householdQuantity.toString();
    }
    _captureInitialValues();
  }

  void _captureInitialValues() {
    _initialMeasureValues
      ..clear()
      ..addEntries(
        measureValues.entries.map(
          (entry) => MapEntry(entry.key, Map<String, String>.from(entry.value)),
        ),
      );
  }

  String _dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$day/$month/$year';
  }

  int? _parseQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 0) {
      return null;
    }
    return parsed;
  }

  void _clearSubmitError() {
    if (hasErrorForKey('submit')) {
      setErrorForObject('submit', null);
    }
    message = null;
  }

  void _clearLoadedForm() {
    activeKind = null;
    activeKindSummary = null;
    _clearFormData();
  }

  void _clearFormData() {
    activeDefinition = null;
    latestCensus = null;
    species = [];
    rows = [];
    measures = [];
    measureValues.clear();
    _initialMeasureValues.clear();
    _syncInputFocusNodes();
  }

  void _syncInputFocusNodes() {
    final nextKeys = [
      for (final row in rows)
        for (final measure in measures) _inputKey(row, measure),
    ];
    final nextKeySet = nextKeys.toSet();
    final removedKeys = _inputFocusNodes.keys
        .where((key) => !nextKeySet.contains(key))
        .toList();
    for (final key in removedKeys) {
      final node = _inputFocusNodes.remove(key);
      if (node == null) {
        continue;
      }
      if (node.hasFocus) {
        node.unfocus();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        node.dispose();
      });
    }
    _visibleInputKeys = nextKeys;
  }

  String _inputKey(CensusSchemaRow row, CensusSchemaMeasure measure) {
    return '${row.rowKey}:${measure.key}';
  }

  String? _nextInputKeyAfter(String key) {
    final index = _visibleInputKeys.indexOf(key);
    if (index == -1 || index + 1 >= _visibleInputKeys.length) {
      return null;
    }
    return _visibleInputKeys[index + 1];
  }

  void _ensureFocusedInputVisible(FocusNode node) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = node.context;
      if (context == null || !node.hasFocus) {
        return;
      }
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 180),
        alignment: 0.12,
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    for (final node in _inputFocusNodes.values) {
      node.dispose();
    }
    _inputFocusNodes.clear();
    super.dispose();
  }

  static String? _normalizeKind(String? kind) {
    if (kind == null || kind.trim().isEmpty) {
      return null;
    }
    return kind.trim().toUpperCase();
  }

  String _kindDisplayName(String? kind) {
    if (kind == 'ANIMAL') {
      return 'Animal census';
    }
    if (kind == 'HUMAN') {
      return 'Human census';
    }
    return 'Census';
  }
}
