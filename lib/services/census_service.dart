import 'package:podd_app/locator.dart';
import 'package:podd_app/models/animal_species.dart';
import 'package:podd_app/models/village_census.dart';
import 'package:podd_app/services/api/census_api.dart';

abstract class ICensusService {
  Future<List<AnimalSpecies>> fetchActiveSpecies();

  Future<VillageCensusSnapshot?> getLatestVillageCensus(int villageId);

  Future<VillageCensusSubmitResult> submitVillageCensusSnapshot({
    required int villageId,
    required DateTime censusDate,
    required List<AnimalCensusFactInput> facts,
  });
}

class CensusService implements ICensusService {
  final CensusApi _censusApi = locator<CensusApi>();

  @override
  Future<List<AnimalSpecies>> fetchActiveSpecies() {
    return _censusApi.fetchActiveSpecies();
  }

  @override
  Future<VillageCensusSnapshot?> getLatestVillageCensus(int villageId) {
    return _censusApi.getLatestVillageCensus(villageId);
  }

  @override
  Future<VillageCensusSubmitResult> submitVillageCensusSnapshot({
    required int villageId,
    required DateTime censusDate,
    required List<AnimalCensusFactInput> facts,
  }) {
    return _censusApi.submitVillageCensusSnapshot(
      villageId: villageId,
      censusDate: _dateOnly(censusDate),
      facts: facts,
    );
  }

  String _dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
