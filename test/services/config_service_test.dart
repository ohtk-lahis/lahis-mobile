import 'package:flutter_test/flutter_test.dart';
import 'package:podd_app/services/config_service.dart';

void main() {
  group('ConfigService.isTruthyConfig', () {
    test('treats common enable values as true', () {
      expect(ConfigService.isTruthyConfig('true'), isTrue);
      expect(ConfigService.isTruthyConfig('TRUE'), isTrue);
      expect(ConfigService.isTruthyConfig('1'), isTrue);
      expect(ConfigService.isTruthyConfig('yes'), isTrue);
      expect(ConfigService.isTruthyConfig('enable'), isTrue);
      expect(ConfigService.isTruthyConfig('enabled'), isTrue);
      expect(ConfigService.isTruthyConfig('  enable  '), isTrue);
    });

    test('missing or falsey values stay false (optional default)', () {
      expect(ConfigService.isTruthyConfig(null), isFalse);
      expect(ConfigService.isTruthyConfig(''), isFalse);
      expect(ConfigService.isTruthyConfig('false'), isFalse);
      expect(ConfigService.isTruthyConfig('0'), isFalse);
      expect(ConfigService.isTruthyConfig('no'), isFalse);
      expect(ConfigService.isTruthyConfig('disable'), isFalse);
    });
  });
}
