import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:podd_app/models/animal_species.dart';
import 'package:podd_app/models/village_census.dart';
import 'package:podd_app/services/api/graph_ql_base_api.dart';

class CensusApi extends GraphQlBaseApi {
  CensusApi(ResolveGraphqlClient client) : super(client);

  Future<List<AnimalSpecies>> fetchActiveSpecies() {
    const query = r'''
      query AnimalSpecies {
        animalSpecies {
          id
          code
          name
          active
          sortOrder
        }
      }
    ''';

    return runGqlQuery<List<AnimalSpecies>>(
      query: query,
      typeConverter: (resp) => (resp['animalSpecies'] as List? ?? const [])
          .map((species) => AnimalSpecies.fromJson(species))
          .toList(),
    );
  }

  Future<VillageCensusSnapshot?> getLatestVillageCensus(int villageId) async {
    const query = r'''
      query LatestVillageCensus($villageId: Int!) {
        latestVillageCensus(villageId: $villageId) {
          id
          censusDate
          submittedAt
          village {
            id
            code
            name
          }
          facts {
            species {
              id
              code
              name
              active
              sortOrder
            }
            animalQuantity
            householdQuantity
          }
        }
      }
    ''';

    if (!await ensureAuthCookieIsSet()) {
      throw GraphQlException(
        message: 'Cookies are invalid',
        query: query,
        queryName: 'LatestVillageCensus',
      );
    }

    final response = await resolveClient().query(
      QueryOptions(
        document: gql(query),
        variables: {'villageId': villageId},
        fetchPolicy: FetchPolicy.networkOnly,
        cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
      ),
    );

    if (response.hasException) {
      if (response.exception?.linkException != null) {
        throw response.exception!.linkException!;
      }
      throw response.exception!;
    }

    final snapshot = response.data?['latestVillageCensus'];
    if (snapshot == null) {
      return null;
    }
    return VillageCensusSnapshot.fromJson(snapshot);
  }

  Future<VillageCensusSubmitResult> submitVillageCensusSnapshot({
    required int villageId,
    required String censusDate,
    required List<AnimalCensusFactInput> facts,
  }) async {
    const mutation = r'''
      mutation SubmitVillageCensusSnapshot(
        $villageId: Int!,
        $censusDate: Date!,
        $facts: [AnimalCensusFactInput!]!
      ) {
        submitVillageCensusSnapshot(
          villageId: $villageId,
          censusDate: $censusDate,
          facts: $facts
        ) {
          result {
            __typename
            ... on VillageCensusSnapshotType {
              id
              censusDate
              submittedAt
              village {
                id
                code
                name
              }
              facts {
                species {
                  id
                  code
                  name
                  active
                  sortOrder
                }
                animalQuantity
                householdQuantity
              }
            }
            ... on VillageCensusSnapshotProblem {
              fields {
                name
                message
              }
              message
            }
          }
        }
      }
    ''';

    try {
      return runGqlMutation<VillageCensusSubmitResult>(
        mutation: mutation,
        variables: {
          'villageId': villageId,
          'censusDate': censusDate,
          'facts': facts.map((fact) => fact.toJson()).toList(),
        },
        parseData: (resp) {
          final result = resp?['result'];
          if (result?['__typename'] == 'VillageCensusSnapshotType') {
            return VillageCensusSubmitSuccess(
              VillageCensusSnapshot.fromJson(result),
            );
          }

          final fieldMessages = (result?['fields'] as List? ?? const [])
              .map((field) => field['message'].toString())
              .toList();
          final message = result?['message']?.toString();
          return VillageCensusSubmitValidationFailure([
            ...fieldMessages,
            if (message != null && message.isNotEmpty) message,
          ]);
        },
      );
    } on OperationException catch (e) {
      return VillageCensusSubmitFailure(e);
    }
  }
}
