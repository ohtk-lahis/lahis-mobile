import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:podd_app/locator.dart';
import 'package:podd_app/models/census_definition.dart';
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
    test('CensusDefinitionVersion cache map round trips runtime schema', () {
      final version = CensusDefinitionVersion.fromJson({
        'id': '7',
        'version': 2,
        'status': 'PUBLISHED',
        'runtimeSchema': {
          'rows': [
            {
              'row_key': 'species:CATTLE',
              'label': 'Cattle',
              'species_id': 1,
              'species_code': 'CATTLE',
              'sort_order': 1,
            }
          ],
          'measures': [
            {
              'key': 'animal_quantity',
              'label': 'Heads',
              'type': 'integer',
              'required': true,
            }
          ],
        },
      });

      final cached = CensusDefinitionVersion.fromCacheMap(
        version.toCacheMap(
          kind: 'ANIMAL',
          fetchedAt: DateTime.parse('2026-05-19T00:00:00Z'),
        ),
      );

      expect(cached.id, 7);
      expect(cached.version, 2);
      expect(cached.runtimeSchema.rows.single.label, 'Cattle');
      expect(cached.runtimeSchema.measures.single.key, 'animal_quantity');
    });

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

    test('getActiveVillageCensusDefinitions parses kind summaries', () async {
      final link = QueueLink([
        {
          '__typename': 'Query',
          'activeVillageCensusDefinitions': [
            {
              '__typename': 'CensusKindSummaryType',
              'kind': 'ANIMAL',
              'name': 'Animal census',
              'enabled': true,
              'activeVersion': {
                '__typename': 'CensusDefinitionVersionType',
                'id': '7',
                'version': 1,
                'status': 'PUBLISHED',
                'runtimeSchema': {
                  'rows': [
                    {
                      'row_key': 'species:CATTLE',
                      'label': 'Cattle',
                      'species_id': 1,
                    }
                  ],
                  'measures': [
                    {
                      'key': 'animal_quantity',
                      'label': 'Heads',
                      'type': 'integer',
                      'required': true,
                    }
                  ],
                },
              },
              'latestSnapshot': {
                '__typename': 'VillageCensusSnapshotType',
                'id': '12',
                'censusDate': '2026-05-19',
                'submittedAt': '2026-05-19T10:00:00Z',
                'definitionVersion': {
                  '__typename': 'CensusDefinitionVersionType',
                  'id': '6',
                  'version': 1,
                  'definition': {
                    '__typename': 'CensusDefinitionType',
                    'kind': 'HUMAN',
                  },
                },
              },
            },
          ],
        }
      ]);
      final api = censusApiFor(link);

      final summaries = await api.getActiveVillageCensusDefinitions(11);

      expect(summaries.single.kind, 'ANIMAL');
      expect(summaries.single.displayName, 'Animal census');
      expect(summaries.single.activeVersion?.id, 7);
      expect(summaries.single.latestSnapshot?.censusDate?.day, 19);
      expect(link.requests.single.variables, {'villageId': 11});
    });

    test('getActiveVillageCensusDefinitions returns empty on legacy server',
        () async {
      final link = QueueLink([
        Response(
          errors: const [
            GraphQLError(
              message:
                  "Cannot query field 'activeVillageCensusDefinitions' on type 'Query'",
            )
          ],
          response: const {
            'errors': [
              {
                'message':
                    "Cannot query field 'activeVillageCensusDefinitions' on type 'Query'"
              }
            ]
          },
        ),
      ]);
      final api = censusApiFor(link);

      final summaries = await api.getActiveVillageCensusDefinitions(11);

      expect(summaries, isEmpty);
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

    test('getLatestVillageCensusV2 parses generic form data', () async {
      final link = QueueLink([
        {
          '__typename': 'Query',
          'latestVillageCensusV2': {
            '__typename': 'VillageCensusSnapshotType',
            'id': '13',
            'censusDate': '2026-05-19',
            'submittedAt': '2026-05-19T10:00:00Z',
            'definitionVersion': {
              '__typename': 'CensusDefinitionVersionType',
              'id': '6',
              'version': 1,
              'definition': {
                '__typename': 'CensusDefinitionType',
                'kind': 'HUMAN',
              },
            },
            'formData': {
              'rows': [
                {
                  'row_key': 'age:under5',
                  'measures': {'people': 12}
                }
              ],
            },
            'village': {
              '__typename': 'VillageType',
              'id': 11,
              'code': 'V001',
              'name': 'Village One',
            },
            'facts': [],
          }
        }
      ]);
      final api = censusApiFor(link);

      final latest = await api.getLatestVillageCensusV2(11, 'HUMAN');

      expect(latest?.formData['rows'], isA<List>());
      expect(latest?.definitionVersionId, 6);
      expect(latest?.definitionVersionNumber, 1);
      expect(link.requests.single.variables, {
        'villageId': 11,
        'kind': 'HUMAN',
      });
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

    test('submitVillageCensusSnapshot classifies animal species changes',
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
                  'name': 'facts',
                  'message': 'ACTIVE_ANIMAL_SPECIES_CHANGED',
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
            animalQuantity: 10,
            householdQuantity: 5,
          ),
        ],
      );

      expect(result, isA<CensusDefinitionChanged>());
    });

    test('submitVillageCensusSnapshotV2 sends definition version and form data',
        () async {
      final formData = {
        'rows': [
          {
            'species_id': 1,
            'measures': {
              'animal_quantity': 5,
              'household_quantity': 2,
            },
          }
        ],
      };
      final link = QueueLink([
        {
          '__typename': 'Mutation',
          'submitVillageCensusSnapshotV2': {
            '__typename': 'SubmitVillageCensusSnapshotV2Mutation',
            'result': {
              '__typename': 'VillageCensusSnapshotType',
              'id': '100',
              'censusDate': '2026-05-05',
              'submittedAt': '2026-05-05T10:00:00Z',
              'formData': formData,
              'definitionVersion': {
                '__typename': 'CensusDefinitionVersionType',
                'id': '7',
                'version': 2,
                'definition': {
                  '__typename': 'CensusDefinitionType',
                  'kind': 'ANIMAL',
                },
              },
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

      final result = await api.submitVillageCensusSnapshotV2(
        villageId: 11,
        definitionVersionId: 7,
        censusDate: '2026-05-05',
        formData: formData,
      );

      expect(result, isA<VillageCensusSubmitSuccess>());
      final success = result as VillageCensusSubmitSuccess;
      expect(success.snapshot.definitionVersionId, 7);
      expect(success.snapshot.definitionVersionNumber, 2);
      expect(success.snapshot.formData, formData);
      expect(link.requests.single.variables['villageId'], 11);
      expect(link.requests.single.variables['definitionVersionId'], 7);
      expect(link.requests.single.variables['formData'], formData);
    });

    test('submitVillageCensusSnapshotV2 classifies retired definition version',
        () async {
      final link = QueueLink([
        {
          '__typename': 'Mutation',
          'submitVillageCensusSnapshotV2': {
            '__typename': 'SubmitVillageCensusSnapshotV2Mutation',
            'result': {
              '__typename': 'VillageCensusSnapshotProblem',
              'message': null,
              'fields': [
                {
                  '__typename': 'AdminFieldValidationProblem',
                  'name': 'definition_version_id',
                  'message': 'census definition version must be published',
                }
              ],
            }
          }
        }
      ]);
      final api = censusApiFor(link);

      final result = await api.submitVillageCensusSnapshotV2(
        villageId: 11,
        definitionVersionId: 7,
        censusDate: '2026-05-05',
        formData: const {'rows': []},
      );

      expect(result, isA<CensusDefinitionChanged>());
    });

    test('submitVillageCensusSnapshotV2 classifies disabled definition',
        () async {
      final link = QueueLink([
        {
          '__typename': 'Mutation',
          'submitVillageCensusSnapshotV2': {
            '__typename': 'SubmitVillageCensusSnapshotV2Mutation',
            'result': {
              '__typename': 'VillageCensusSnapshotProblem',
              'message': null,
              'fields': [
                {
                  '__typename': 'AdminFieldValidationProblem',
                  'name': 'definition_version_id',
                  'message': 'DEFINITION_DISABLED',
                }
              ],
            }
          }
        }
      ]);
      final api = censusApiFor(link);

      final result = await api.submitVillageCensusSnapshotV2(
        villageId: 11,
        definitionVersionId: 7,
        censusDate: '2026-05-05',
        formData: const {'rows': []},
      );

      expect(result, isA<CensusDefinitionChanged>());
    });

    test('submitVillageCensusSnapshotV2 classifies animal species changes',
        () async {
      final link = QueueLink([
        {
          '__typename': 'Mutation',
          'submitVillageCensusSnapshotV2': {
            '__typename': 'SubmitVillageCensusSnapshotV2Mutation',
            'result': {
              '__typename': 'VillageCensusSnapshotProblem',
              'message': null,
              'fields': [
                {
                  '__typename': 'AdminFieldValidationProblem',
                  'name': 'form_data.rows',
                  'message': 'ACTIVE_ANIMAL_SPECIES_CHANGED',
                }
              ],
            }
          }
        }
      ]);
      final api = censusApiFor(link);

      final result = await api.submitVillageCensusSnapshotV2(
        villageId: 11,
        definitionVersionId: 7,
        censusDate: '2026-05-05',
        formData: const {'rows': []},
      );

      expect(result, isA<CensusDefinitionChanged>());
    });

    test('submitVillageCensusSnapshotV2 reports unsupported legacy server',
        () async {
      final link = QueueLink([
        Response(
          errors: const [
            GraphQLError(
              message:
                  "Cannot query field 'submitVillageCensusSnapshotV2' on type 'Mutation'",
            )
          ],
          response: const {
            'errors': [
              {
                'message':
                    "Cannot query field 'submitVillageCensusSnapshotV2' on type 'Mutation'"
              }
            ]
          },
        ),
      ]);
      final api = censusApiFor(link);

      final result = await api.submitVillageCensusSnapshotV2(
        villageId: 11,
        definitionVersionId: 7,
        censusDate: '2026-05-05',
        formData: const {'rows': []},
      );

      expect(result, isA<VillageCensusSubmitUnsupported>());
    });
  });
}
