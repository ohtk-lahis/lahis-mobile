import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:podd_app/locator.dart';
import 'package:podd_app/services/api/feature_capability_api.dart';

class SingleResponseLink extends Link {
  final Response response;

  SingleResponseLink(this.response);

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    return Stream.value(response);
  }
}

class SingleErrorLink extends Link {
  final LinkException exception;

  SingleErrorLink(this.exception);

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    return Stream.error(exception);
  }
}

GraphQLClient clientFor(Link link) {
  return GraphQLClient(link: link, cache: GraphQLCache());
}

FeatureCapabilityApi featureCapabilityApiFor(Link link) {
  final api = FeatureCapabilityApi(() => clientFor(link));
  api.baseLogger = null;
  return api;
}

void main() {
  setUpAll(() {
    if (!locator.isRegistered<Logger>()) {
      locator.registerSingleton<Logger>(Logger());
    }
  });

  group('FeatureCapabilityApi GraphQL contract', () {
    test('fetchVillageEnabled parses capability query response', () async {
      final api = featureCapabilityApiFor(
        SingleResponseLink(
          Response(
            data: {
              '__typename': 'Query',
              'villageCapabilityEnabled': true,
            },
            response: {
              'data': {
                '__typename': 'Query',
                'villageCapabilityEnabled': true,
              },
            },
          ),
        ),
      );

      final enabled = await api.fetchVillageEnabled();

      expect(enabled, isTrue);
    });

    test('fetchVillageEnabled treats GraphQL unknown field as disabled',
        () async {
      final api = featureCapabilityApiFor(
        SingleResponseLink(
          Response(
            errors: const [
              GraphQLError(
                message:
                    "Cannot query field 'villageCapabilityEnabled' on type 'Query'.",
              ),
            ],
            response: {
              'errors': [
                {
                  'message':
                      "Cannot query field 'villageCapabilityEnabled' on type 'Query'.",
                }
              ],
            },
          ),
        ),
      );

      final enabled = await api.fetchVillageEnabled();

      expect(enabled, isFalse);
    });

    test('fetchVillageEnabled treats Dio 400 unknown field as disabled',
        () async {
      const parsedResponse = Response(
        errors: [
          GraphQLError(
            message:
                "Cannot query field 'villageCapabilityEnabled' on type 'Query'.",
          ),
        ],
        response: {
          'errors': [
            {
              'message':
                  "Cannot query field 'villageCapabilityEnabled' on type 'Query'.",
            }
          ],
        },
      );
      final api = featureCapabilityApiFor(
        SingleErrorLink(
          DioLinkServerException(
            response: dio.Response(
              requestOptions: dio.RequestOptions(path: '/graphql/'),
              statusCode: 400,
            ),
            parsedResponse: parsedResponse,
            statusCode: 400,
          ),
        ),
      );

      final enabled = await api.fetchVillageEnabled();

      expect(enabled, isFalse);
    });
  });
}
