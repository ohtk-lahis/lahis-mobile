import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:podd_app/locator.dart';
import 'package:podd_app/models/village_census.dart';
import 'package:podd_app/services/api/census_api.dart';

class QueueLink extends Link {
  final List<dynamic> responses;
  final requests = <Request>[];

  QueueLink(this.responses);

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    requests.add(request);
    final response = responses.removeAt(0);
    if (response is Response) {
      return Stream.value(response);
    }
    final data = response as Map<String, dynamic>;
    return Stream.value(Response(data: data, response: {'data': data}));
  }
}

GraphQLClient clientFor(QueueLink link) {
  return GraphQLClient(link: link, cache: GraphQLCache());
}

CensusApi censusApiFor(QueueLink link) {
  final api = CensusApi(() => clientFor(link));
  api.baseLogger = null;
  return api;
}

void main() {
  setUpAll(() {
    if (!locator.isRegistered<Logger>()) {
      locator.registerSingleton<Logger>(Logger());
    }
  });

  group('CensusApi GraphQL contract', () {
    test('fetchActiveSpecies parses active species list', () async {
      final link = QueueLink([
        {
          '__typename': 'Query',
          'animalSpecies': [
            {
              '__typename': 'AnimalSpeciesType',
              'id': 1,
              'code': 'CATTLE',
              'name': 'Cattle',
              'active': true,
              'sortOrder': 1,
            },
            {
              '__typename': 'AnimalSpeciesType',
              'id': 2,
              'code': 'BUFFALO',
              'name': 'Buffalo',
              'active': true,
              'sortOrder': 2,
            },
          ],
        }
      ]);
      final api = censusApiFor(link);

      final species = await api.fetchActiveSpecies();

      expect(species.map((item) => item.displayName), [
        'CATTLE - Cattle',
        'BUFFALO - Buffalo',
      ]);
      expect(link.requests.single.variables, isEmpty);
    });

    test('getActiveCensusDefinitionVersion parses runtime schema', () async {
      final link = QueueLink([
        {
          '__typename': 'Query',
          'activeCensusDefinitionVersion': {
            '__typename': 'CensusDefinitionVersionType',
            'id': '7',
            'version': 1,
            'status': 'PUBLISHED',
            'runtimeSchema': {
              'row_source': 'ACTIVE_ANIMAL_SPECIES',
              'rows': [
                {
                  'species_id': '1',
                  'species_code': 'CATTLE',
                  'label': 'Cattle',
                  'row_key': 'species:CATTLE',
                }
              ],
              'measures': [
                {
                  'key': 'animal_quantity',
                  'label': 'Animal quantity',
                  'type': 'integer',
                  'required': true,
                },
                {
                  'key': 'household_quantity',
                  'label': 'Households',
                  'type': 'integer',
                  'required': true,
                },
              ],
            },
          }
        }
      ]);
      final api = censusApiFor(link);

      final version = await api.getActiveCensusDefinitionVersion('ANIMAL');

      expect(version?.id, 7);
      expect(version?.runtimeSchema.supportsLegacyAnimalSubmit, isTrue);
      expect(
        version?.runtimeSchema.toAnimalSpeciesRows().single.displayName,
        'CATTLE - Cattle',
      );
      expect(link.requests.single.variables, {'kind': 'ANIMAL'});
    });

    test('getActiveCensusDefinitionVersion returns null on legacy server',
        () async {
      final link = QueueLink([
        Response(
          errors: const [
            GraphQLError(
              message:
                  "Cannot query field 'activeCensusDefinitionVersion' on type 'Query'",
            )
          ],
          response: const {
            'errors': [
              {
                'message':
                    "Cannot query field 'activeCensusDefinitionVersion' on type 'Query'"
              }
            ]
          },
        ),
      ]);
      final api = censusApiFor(link);

      final version = await api.getActiveCensusDefinitionVersion('ANIMAL');

      expect(version, isNull);
      expect(link.requests.single.variables, {'kind': 'ANIMAL'});
    });

    test('getLatestVillageCensus returns null when no snapshot exists',
        () async {
      final link = QueueLink([
        {'__typename': 'Query', 'latestVillageCensus': null}
      ]);
      final api = censusApiFor(link);

      final latest = await api.getLatestVillageCensus(11);

      expect(latest, isNull);
      expect(link.requests.single.variables, {'villageId': 11});
    });

    test('submitVillageCensusSnapshot parses success union', () async {
      final link = QueueLink([
        {
          '__typename': 'Mutation',
          'submitVillageCensusSnapshot': {
            '__typename': 'SubmitVillageCensusSnapshotMutation',
            'result': {
              '__typename': 'VillageCensusSnapshotType',
              'id': 99,
              'censusDate': '2026-05-05',
              'submittedAt': '2026-05-05T10:00:00Z',
              'village': {
                '__typename': 'VillageType',
                'id': 11,
                'code': 'V001',
                'name': 'Village One',
              },
              'facts': [
                {
                  'species': {
                    '__typename': 'AnimalSpeciesType',
                    'id': 1,
                    'code': 'CATTLE',
                    'name': 'Cattle',
                    'active': true,
                    'sortOrder': 1,
                  },
                  'animalQuantity': 5,
                  'householdQuantity': 2,
                }
              ],
            }
          }
        }
      ]);
      final api = censusApiFor(link);

      final result = await api.submitVillageCensusSnapshot(
        villageId: 11,
        censusDate: '2026-05-05',
        facts: const [
          AnimalCensusFactInput(
            speciesId: 1,
            animalQuantity: 5,
            householdQuantity: 2,
          )
        ],
      );

      expect(result, isA<VillageCensusSubmitSuccess>());
      final success = result as VillageCensusSubmitSuccess;
      expect(success.snapshot.facts.single.animalQuantity, 5);
      expect(link.requests.single.variables['villageId'], 11);
      expect(link.requests.single.variables['facts'], [
        {'speciesId': 1, 'animalQuantity': 5, 'householdQuantity': 2}
      ]);
    });

    test('submitVillageCensusSnapshot parses validation problem union',
        () async {
      final link = QueueLink([
        {
          '__typename': 'Mutation',
          'submitVillageCensusSnapshot': {
            '__typename': 'SubmitVillageCensusSnapshotMutation',
            'result': {
              '__typename': 'VillageCensusSnapshotProblem',
              'message': null,
              'fields': [
                {
                  '__typename': 'AdminFieldValidationProblem',
                  'name': 'village_id',
                  'message': 'reporter is not official for this village',
                }
              ],
            }
          }
        }
      ]);
      final api = censusApiFor(link);

      final result = await api.submitVillageCensusSnapshot(
        villageId: 11,
        censusDate: '2026-05-05',
        facts: const [],
      );

      expect(result, isA<VillageCensusSubmitValidationFailure>());
      final failure = result as VillageCensusSubmitValidationFailure;
      expect(failure.messages, ['reporter is not official for this village']);
    });
  });
}
