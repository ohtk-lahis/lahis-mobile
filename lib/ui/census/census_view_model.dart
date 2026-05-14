import 'package:podd_app/locator.dart';
import 'package:podd_app/models/animal_species.dart';
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
  VillageCensusSnapshot? latestCensus;
  final animalQuantities = <int, String>{};
  final householdQuantities = <int, String>{};
  String? message;

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

  Future<void> init() async {
    setBusy(true);
    message = null;
    clearErrors();

    if (!hasCensusAccess) {
      setBusy(false);
      return;
    }

    try {
      species = await censusService.fetchActiveSpecies();
      for (final item in species) {
        animalQuantities.putIfAbsent(item.id, () => '');
        householdQuantities.putIfAbsent(item.id, () => '');
      }
      latestCensus =
          await censusService.getLatestVillageCensus(selectedVillage!.id);
    } catch (e) {
      setError(e.toString());
    }

    setBusy(false);
  }

  void setAnimalQuantity(int speciesId, String value) {
    animalQuantities[speciesId] = value.trim();
    _clearSubmitError();
  }

  void setHouseholdQuantity(int speciesId, String value) {
    householdQuantities[speciesId] = value.trim();
    _clearSubmitError();
  }

  Future<VillageCensusSubmitResult?> submit() async {
    _clearSubmitError();
    message = null;

    if (!hasCensusAccess) {
      setErrorForObject('submit', 'Village census is not available.');
      return null;
    }

    final facts = _buildFacts();
    if (facts == null) {
      notifyListeners();
      return null;
    }

    setBusyForObject('submit', true);
    VillageCensusSubmitResult? result;
    try {
      result = await censusService.submitVillageCensusSnapshot(
        villageId: selectedVillage!.id,
        censusDate: DateTime.now(),
        facts: facts,
      );
    } catch (e) {
      setErrorForObject('submit', e.toString());
    } finally {
      setBusyForObject('submit', false);
    }

    if (result is VillageCensusSubmitSuccess) {
      latestCensus = result.snapshot;
      message = 'Census submitted.';
    } else if (result is VillageCensusSubmitValidationFailure) {
      setErrorForObject('submit', result.messages.join(', '));
    } else if (result is VillageCensusSubmitFailure) {
      setErrorForObject('submit', result.messages.join(', '));
    }

    notifyListeners();
    return result;
  }

  List<AnimalCensusFactInput>? _buildFacts() {
    final facts = <AnimalCensusFactInput>[];
    for (final item in species) {
      final animalQuantity = _parseQuantity(animalQuantities[item.id]);
      final householdQuantity = _parseQuantity(householdQuantities[item.id]);

      if (animalQuantity == null || householdQuantity == null) {
        setErrorForObject(
          'submit',
          'Enter non-negative animal and household quantities for every species.',
        );
        return null;
      }

      facts.add(
        AnimalCensusFactInput(
          speciesId: item.id,
          animalQuantity: animalQuantity,
          householdQuantity: householdQuantity,
        ),
      );
    }
    return facts;
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
