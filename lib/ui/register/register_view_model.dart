import 'package:podd_app/locator.dart';
import 'package:podd_app/models/inviation_code_result.dart';
import 'package:podd_app/models/register_result.dart';
import 'package:podd_app/models/village.dart';
import 'package:podd_app/services/register_service.dart';
import 'package:stacked/stacked.dart';
import 'package:podd_app/l10n/app_localizations.dart';

enum RegisterState { invitation, detail }

class RegisterViewModel extends BaseViewModel {
  IRegisterService registerService = locator<IRegisterService>();

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
      notifyListeners();
    } else if (result is InvitationCodeFailure) {
      setErrorForObject("invitationCode", result.messages.join(','));
    }

    setBusy(false);
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
    );

    if (result is RegisterFailure) {
      setErrorForObject("submit", result.messages.join(','));
    }

    setBusy(false);
    return result;
  }
}
