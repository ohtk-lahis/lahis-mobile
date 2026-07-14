import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:podd_app/services/api/graph_ql_base_api.dart';

class FeatureCapabilityApi extends GraphQlBaseApi {
  FeatureCapabilityApi(ResolveGraphqlClient client) : super(client);

  Future<bool> fetchVillageEnabled() async {
    const query = r'''
      query VillageCapability {
        villageCapabilityEnabled
      }
    ''';

    final response = await resolveClient().query(
      QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
        cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
      ),
    );

    if (!response.hasException) {
      return response.data?['villageCapabilityEnabled'] == true;
    }

    if (_hasUnsupportedField(response.exception, 'villageCapabilityEnabled')) {
      return false;
    }

    throw response.exception!;
  }

  bool _hasUnsupportedField(OperationException? exception, String fieldName) {
    final errors = exception?.graphqlErrors ?? const [];
    if (errors.any(
      (error) => error.message.contains("Cannot query field '$fieldName'"),
    )) {
      return true;
    }

    return exception?.linkException
            ?.toString()
            .contains("Cannot query field '$fieldName'") ??
        false;
  }
}
