import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:podd_app/services/api/graph_ql_base_api.dart';

class FeatureCapabilityApi extends GraphQlBaseApi {
  FeatureCapabilityApi(ResolveGraphqlClient client) : super(client);

  static const villageFeatureKey = 'features.village_enabled';

  Future<bool> fetchVillageEnabled() async {
    final directResult = await _fetchVillageEnabledFromCapabilityQuery();
    if (directResult != null) {
      return directResult;
    }

    return _fetchVillageEnabledFromLegacyFeatures();
  }

  Future<bool?> _fetchVillageEnabledFromCapabilityQuery() async {
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
      return null;
    }

    throw response.exception!;
  }

  Future<bool> _fetchVillageEnabledFromLegacyFeatures() async {
    const query = r'''
      query Features {
        features {
          key
          value
        }
      }
    ''';

    final response = await resolveClient().query(
      QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
        cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
      ),
    );

    if (response.hasException) {
      if (_hasUnsupportedField(response.exception, 'features')) {
        return false;
      }
      throw response.exception!;
    }

    final features = response.data?['features'] as List? ?? const [];
    for (final feature in features) {
      if (feature is Map &&
          feature['key'] == villageFeatureKey &&
          feature['value'] == 'enable') {
        return true;
      }
    }
    return false;
  }

  bool _hasUnsupportedField(OperationException? exception, String fieldName) {
    final errors = exception?.graphqlErrors ?? const [];
    return errors.any(
      (error) => error.message.contains("Cannot query field '$fieldName'"),
    );
  }
}
