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
  List<CensusSchemaRow> rows = [];
  List<CensusSchemaMeasure> measures = [];
  CensusDefinitionVersion? activeDefinition;
  VillageCensusSnapshot? latestCensus;
  final measureValues = <String, Map<String, String>>{};
  final _initialMeasureValues = <String, Map<String, String>>{};
  String? message;
  bool usingCachedDefinition = false;
  bool unsupportedSchema = false;
  bool _canSubmitWithLegacyMutation = true;

  CensusViewModel() {
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

    if (!hasCensusAccess) {
      setBusy(false);
      return;
    }

    try {
      await _loadAnimalCensusRows();
      latestCensus =
          await censusService.getLatestVillageCensus(selectedVillage!.id);
      _prefillFromLatestCensus();
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

      if (row.speciesId == null) {
        setErrorForObject(
          'submit',
          'This census form is not supported by this app version.',
        );
        return null;
      }

      formRows.add({
        'species_id': row.speciesId,
        'measures': measureMap,
      });
    }
    return {'rows': formRows};
  }

  Future<void> _loadAnimalCensusRows() async {
    _canSubmitWithLegacyMutation = true;
    usingCachedDefinition = false;
    unsupportedSchema = false;
    activeDefinition = null;
    CensusDefinitionVersion? definition;

    try {
      definition = await censusService.getActiveCensusDefinitionVersion(
        kind: 'ANIMAL',
      );
    } catch (_) {
      definition = await censusService.getCachedCensusDefinitionVersion(
        kind: 'ANIMAL',
      );
      usingCachedDefinition = definition != null;
      if (definition == null) {
        rethrow;
      }
    }

    if (definition == null) {
      species = await censusService.fetchActiveSpecies();
      _useLegacySpeciesRows(species);
    } else {
      activeDefinition = definition;
      rows = definition.runtimeSchema.rows;
      measures = definition.runtimeSchema.measures;
      species = definition.runtimeSchema.toAnimalSpeciesRows();
      unsupportedSchema = !definition.runtimeSchema.supportsMobileAnimalSubmit;
      _canSubmitWithLegacyMutation =
          definition.runtimeSchema.supportsLegacyAnimalSubmit;
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
    _captureInitialValues();
  }

  void _prefillFromLatestCensus() {
    if (latestCensus == null) {
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
}
