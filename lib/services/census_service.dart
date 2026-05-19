import 'package:podd_app/locator.dart';
import 'package:podd_app/models/animal_species.dart';
import 'package:podd_app/models/census_definition.dart';
import 'package:podd_app/models/village_census.dart';
import 'package:podd_app/services/api/census_api.dart';
import 'package:podd_app/services/db_service.dart';
import 'package:sqflite/sqflite.dart';

abstract class ICensusService {
  Future<List<AnimalSpecies>> fetchActiveSpecies();

  Future<CensusDefinitionVersion?> getActiveCensusDefinitionVersion({
    required String kind,
  });

  Future<CensusDefinitionVersion?> getCachedCensusDefinitionVersion({
    required String kind,
  });

  Future<VillageCensusSnapshot?> getLatestVillageCensus(int villageId);

  Future<VillageCensusSubmitResult> submitVillageCensusSnapshot({
    required int villageId,
    required DateTime censusDate,
    required List<AnimalCensusFactInput> facts,
  });

  Future<VillageCensusSubmitResult> submitVillageCensusSnapshotV2({
    required int villageId,
    required int definitionVersionId,
    required DateTime censusDate,
    required Map<String, dynamic> formData,
  });
}

class CensusService implements ICensusService {
  final CensusApi _censusApi = locator<CensusApi>();
  final IDbService _dbService = locator<IDbService>();

  @override
  Future<List<AnimalSpecies>> fetchActiveSpecies() {
    return _censusApi.fetchActiveSpecies();
  }

  @override
  Future<CensusDefinitionVersion?> getActiveCensusDefinitionVersion({
    required String kind,
  }) async {
    final definition = await _censusApi.getActiveCensusDefinitionVersion(kind);
    if (definition != null) {
      await _cacheDefinition(kind, definition);
    }
    return definition;
  }

  @override
  Future<CensusDefinitionVersion?> getCachedCensusDefinitionVersion({
    required String kind,
  }) async {
    await _ensureDefinitionCacheTable();
    final results = await _dbService.db.query(
      'census_definition_cache',
      where: 'kind = ?',
      whereArgs: [kind],
      limit: 1,
    );
    if (results.isEmpty) {
      return null;
    }
    return CensusDefinitionVersion.fromCacheMap(results.first);
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

  @override
  Future<VillageCensusSubmitResult> submitVillageCensusSnapshotV2({
    required int villageId,
    required int definitionVersionId,
    required DateTime censusDate,
    required Map<String, dynamic> formData,
  }) {
    return _censusApi.submitVillageCensusSnapshotV2(
      villageId: villageId,
      definitionVersionId: definitionVersionId,
      censusDate: _dateOnly(censusDate),
      formData: formData,
    );
  }

  Future<void> _cacheDefinition(
    String kind,
    CensusDefinitionVersion definition,
  ) async {
    await _ensureDefinitionCacheTable();
    await _dbService.db.insert(
      'census_definition_cache',
      definition.toCacheMap(kind: kind, fetchedAt: DateTime.now()),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _ensureDefinitionCacheTable() async {
    await _dbService.db
        .execute('''CREATE TABLE IF NOT EXISTS census_definition_cache (
      kind TEXT PRIMARY KEY,
      definition_version_id INT,
      version INT,
      status TEXT,
      runtime_schema_json TEXT,
      fetched_at TEXT
    )''');
  }

  String _dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
