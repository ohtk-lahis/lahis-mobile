import 'package:logger/logger.dart';
import 'package:podd_app/locator.dart';
import 'package:podd_app/models/inviation_code_result.dart';
import 'package:podd_app/models/register_result.dart';
import 'package:podd_app/models/village.dart';
import 'package:podd_app/services/api/configuration_api.dart';
import 'package:podd_app/services/config_service.dart';
import 'package:podd_app/services/register_service.dart';
import 'package:stacked/stacked.dart';
import 'package:podd_app/l10n/app_localizations.dart';

enum RegisterState { invitation, detail }

/// Backend gender enum values for [AuthorityUser.Gender].
class RegisterGender {
  static const male = 'male';
  static const female = 'female';
  static const other = 'other';

  static const values = [male, female, other];
}

class RegisterViewModel extends BaseViewModel {
  IRegisterService registerService = locator<IRegisterService>();
  ConfigurationApi configurationApi = locator<ConfigurationApi>();
  ConfigService configService = locator<ConfigService>();
  final logger = locator<Logger>();

  RegisterState state = RegisterState.invitation;
  final localize = locator<AppLocalizations>();

  String? invitationCode;
  String? authorityName;
  List<Village> villages = [];

  String? username;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? address;
  String? gender;
  int? age;
  bool consentAccepted = false;

  /// Tenant config: missing key → optional (safe for non-FAO tenants).
  bool genderRequired = false;
  bool ageRequired = false;

  /// From existing consent configs (`mobile.consent.msg` / accept text).
  /// Empty body → consent UI hidden (legacy tenants without consent).
  String consentContent = '';
  String consentAcceptText = '';

  bool get showConsent => consentContent.trim().isNotEmpty;

  String get consentCheckboxLabel => consentAcceptText.trim().isNotEmpty
      ? consentAcceptText.trim()
      : localize.registerConsentLabel;

  setInvitationCode(value) {
    invitationCode = value;
  }

  checkInvitationCode() async {
    setBusy(true);
    if (invitationCode == null || invitationCode!.isEmpty) {
      setErrorForObject("invitationCode", localize.invitationCodeIsRequired);
      setBusy(false);
      return;
    }

    var result = await registerService.checkInvitationCode(invitationCode!);
    if (result is InvitationCodeSuccess) {
      state = RegisterState.detail;
      authorityName = result.authorityName;
      villages = result.villages;
      username = result.generatedUsername;
      email = result.generatedEmail;
      await _loadRegisterConfiguration();
      notifyListeners();
    } else if (result is InvitationCodeFailure) {
      setErrorForObject("invitationCode", result.messages.join(','));
    }

    setBusy(false);
  }

  Future<void> _loadRegisterConfiguration() async {
    genderRequired = false;
    ageRequired = false;
    consentContent = '';
    consentAcceptText = '';
    consentAccepted = false;

    try {
      final result = await configurationApi.getConfigurations();
      final byKey = {
        for (final config in result.data) config.key: config.value,
      };

      genderRequired = ConfigService.isTruthyConfig(
        byKey[configService.registerGenderRequiredKey],
      );
      ageRequired = ConfigService.isTruthyConfig(
        byKey[configService.registerAgeRequiredKey],
      );

      consentContent = byKey[configService.consentConfigurationKey] ?? '';
      consentAcceptText = byKey[configService.consentAcceptTextKey] ?? '';
    } catch (e, stack) {
      // Fail open: treat as optional fields + no consent (non-FAO safe).
      logger.w('Failed to load register configuration: $e\n$stack');
    }
  }

  bool get hasVillages => villages.isNotEmpty;

  String get villageNames =>
      villages.map((village) => village.displayName).join(', ');

  _clearErrorForKey(String key) {
    if (hasErrorForKey(key)) {
      setErrorForObject(key, null);
    }
  }

  void setUsername(String value) {
    username = value.trim();
    _clearErrorForKey('username');
  }

  void setFirstName(String value) {
    firstName = value.trim();
    _clearErrorForKey('firstName');
  }

  void setLastName(String value) {
    lastName = value.trim();
    _clearErrorForKey('lastName');
  }

  void setEmail(String value) {
    email = value.trim();
    _clearErrorForKey('email');
  }

  void setPhone(String value) {
    phone = value.trim();
    _clearErrorForKey('phone');
  }

  void setAddress(String value) {
    address = value.trim();
    _clearErrorForKey('address');
  }

  void setGender(String? value) {
    gender = value;
    _clearErrorForKey('gender');
    notifyListeners();
  }

  void setAge(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      age = null;
    } else {
      age = int.tryParse(trimmed);
    }
    _clearErrorForKey('age');
  }

  void setConsentAccepted(bool? value) {
    consentAccepted = value ?? false;
    _clearErrorForKey('consent');
    notifyListeners();
  }

  Future<RegisterResult> register() async {
    _clearErrorForKey('submit');
    setBusy(true);
    var isValidData = true;
    if (username == null || username!.isEmpty) {
      setErrorForObject("username", localize.fieldRequired);
      isValidData = false;
    }
    if (firstName == null || firstName!.isEmpty) {
      setErrorForObject("firstName", localize.fieldRequired);
      isValidData = false;
    }
    if (lastName == null || lastName!.isEmpty) {
      setErrorForObject("lastName", localize.fieldRequired);
      isValidData = false;
    }
    if (email == null || email!.isEmpty) {
      setErrorForObject("email", localize.fieldRequired);
      isValidData = false;
    }
    if (phone == null || phone!.isEmpty) {
      setErrorForObject("phone", localize.fieldRequired);
      isValidData = false;
    }
    if (genderRequired && (gender == null || gender!.isEmpty)) {
      setErrorForObject("gender", localize.fieldRequired);
      isValidData = false;
    }
    if (ageRequired && age == null) {
      setErrorForObject("age", localize.fieldRequired);
      isValidData = false;
    } else if (age != null && (age! < 1 || age! > 120)) {
      setErrorForObject("age", localize.registerAgeInvalid);
      isValidData = false;
    }
    if (showConsent && !consentAccepted) {
      setErrorForObject("consent", localize.registerConsentRequired);
      isValidData = false;
    }
    // test email regexp
    if (email != null &&
        !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email!)) {
      setErrorForObject("email", "Email is invalid");
      isValidData = false;
    }

    if (!isValidData) {
      setBusy(false);
      return RegisterInvalidData();
    }

    var result = await registerService.registerUser(
      invitationCode: invitationCode!,
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      gender: (gender == null || gender!.isEmpty) ? null : gender,
      age: age,
      consent: showConsent ? consentAccepted : false,
    );

    if (result is RegisterFailure) {
      setErrorForObject("submit", result.messages.join(','));
    }

    setBusy(false);
    return result;
  }
}
