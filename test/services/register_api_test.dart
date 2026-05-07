import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:podd_app/locator.dart';
import 'package:podd_app/models/inviation_code_result.dart';
import 'package:podd_app/services/api/register_api.dart';

class QueueLink extends Link {
  final List<Map<String, dynamic>> responses;
  final requests = <Request>[];

  QueueLink(this.responses);

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    requests.add(request);
    final data = responses.removeAt(0);
    return Stream.value(Response(data: data, response: {'data': data}));
  }
}

GraphQLClient clientFor(QueueLink link) {
  return GraphQLClient(link: link, cache: GraphQLCache());
}

RegisterApi registerApiFor(QueueLink link) {
  final api = RegisterApi(() => clientFor(link));
  api.baseLogger = null;
  return api;
}

void main() {
  setUpAll(() {
    if (!locator.isRegistered<Logger>()) {
      locator.registerSingleton<Logger>(Logger());
    }
  });

  group('RegisterApi GraphQL contract', () {
    test('checkInvitationCode parses scoped villages', () async {
      final link = QueueLink([
        {
          '__typename': 'Query',
          'checkInvitationCode': {
            '__typename': 'CheckInvitationCodeType',
            'code': 'INV001',
            'generatedUsername': 'reporter001',
            'generatedEmail': 'reporter001@example.test',
            'authority': {
              '__typename': 'AuthorityType',
              'code': 'AUTH',
              'name': 'Authority',
            },
            'villages': [
              {
                '__typename': 'VillageType',
                'id': 11,
                'code': 'V001',
                'name': 'Village One',
              },
              {
                '__typename': 'VillageType',
                'id': 12,
                'code': 'V002',
                'name': 'Village Two',
              },
            ],
          }
        }
      ]);
      final api = registerApiFor(link);

      final result = await api.checkInvitationCode('INV001');

      expect(result, isA<InvitationCodeSuccess>());
      final success = result as InvitationCodeSuccess;
      expect(success.authorityName, 'Authority');
      expect(success.generatedUsername, 'reporter001');
      expect(success.generatedEmail, 'reporter001@example.test');
      expect(success.villageNames, 'V001 - Village One, V002 - Village Two');
      expect(link.requests.single.variables, {'code': 'INV001'});
    });
  });
}
