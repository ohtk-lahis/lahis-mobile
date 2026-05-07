import 'package:dio/dio.dart';
import 'package:podd_app/constants.dart';
import 'package:podd_app/locator.dart';
import 'package:podd_app/services/config_service.dart';
import 'package:podd_app/services/gql_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class WelcomeViewModel extends BaseViewModel {
  ConfigService configService = locator<ConfigService>();
  GqlService gqlService = locator<GqlService>();

  final _dio = Dio();

  List<Map<String, String>> servers = [];
  bool loadFailed = false;

  String? selectedLanguage;
  String? selectedServerId;

  bool get continueEnabled =>
      selectedLanguage != null &&
      selectedLanguage!.isNotEmpty &&
      selectedServerId != null &&
      selectedServerId!.isNotEmpty;

  WelcomeViewModel() {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    setBusyForObject('tenants', true);
    loadFailed = false;

    final prefs = await SharedPreferences.getInstance();
    selectedLanguage = prefs.getString(languageKey);
    final storedServer = prefs.getString(gqlService.backendUrlKey);

    try {
      final resp = await _dio.get(configService.tenantApiEndpoint);
      final tenants = (resp.data['tenants'] as List)
          .map<Map<String, String>>((it) =>
              {'label': it['label'], 'domain': it['domain']})
          .toList();
      servers = tenants;

      if (storedServer != null &&
          tenants.any((t) => t['domain'] == storedServer)) {
        selectedServerId = storedServer;
      }
      notifyListeners();
    } catch (e) {
      loadFailed = true;
    } finally {
      setBusyForObject('tenants', false);
    }
  }

  Future<void> selectLanguage(String code) async {
    selectedLanguage = code;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, code);
  }

  void selectServer(String domain) {
    selectedServerId = domain;
    notifyListeners();
  }

  Future<void> submit() async {
    if (!continueEnabled) return;
    setBusy(true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, selectedLanguage!);
    await gqlService.setBackendSubDomain(selectedServerId!);
    setBusy(false);
  }
}
