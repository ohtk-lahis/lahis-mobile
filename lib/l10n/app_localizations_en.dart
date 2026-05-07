// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'OHTK Mobile';

  @override
  String get loginTitle => 'Login to Your Account';

  @override
  String get signupTitle => 'Sign Up';

  @override
  String get signupSubTitle => 'Please enter Invitation Code\nfor registration';

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get forgotPasswordSubTitle =>
      'Please enter your email address and we will send you a password reset link';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get incidentsTabTitle => 'Incidents';

  @override
  String get observationsTabTitle => 'Observations';

  @override
  String get profileTabTitle => 'Profile';

  @override
  String get caseTag => 'Case';

  @override
  String get reportTitle => 'Report';

  @override
  String get reportTypeTitle => 'Report type';

  @override
  String get reportDetailTitle => 'Report detail';

  @override
  String get followupTitle => 'Followup';

  @override
  String get followupDetailTitle => 'Followup detail';

  @override
  String get profileTitle => 'Profile';

  @override
  String get loginButton => 'Login';

  @override
  String get qrCodeLoginButton => 'QRCode LOGIN';

  @override
  String get pickQrcodeImageButton => 'Choose QRCode image';

  @override
  String get getLoginQrcodeButton => 'my QR login';

  @override
  String get logoutButton => 'Logout';

  @override
  String get registerButton => 'Register';

  @override
  String get forgotPasswordButton => 'Forgot Password';

  @override
  String get messagesPageTitle => 'Messages';

  @override
  String get messagePageTitle => 'Message';

  @override
  String get formPageLabel => 'Page';

  @override
  String get backButton => 'Back';

  @override
  String get formBackButton => 'back';

  @override
  String get nextButton => 'Next';

  @override
  String get formNextButton => 'next';

  @override
  String get submitButton => 'Submit';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get confirmRegisterButton => 'Confirm Register';

  @override
  String get sendButton => 'Send';

  @override
  String get updateProfileButton => 'Update Profile';

  @override
  String get confirmUpdate => 'Confirm Update';

  @override
  String get profileUpdateSuccess => 'Profile Updated';

  @override
  String get passwordUpdatedSuccess =>
      'Your password has been successfully changed!';

  @override
  String get changePasswordButton => 'Change Password';

  @override
  String get laguageLabel => 'Language';

  @override
  String get serverLabel => 'Server';

  @override
  String get usernameLabel => 'Username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get invitationCodeLabel => 'Invitation Code';

  @override
  String get firstNameLabel => 'First Name';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'tester@gmail.com';

  @override
  String get telephoneLabel => 'Telephone';

  @override
  String get addressLabel => 'Address';

  @override
  String get allReportTabLabel => 'All Reports';

  @override
  String get myReportTabLabel => 'My Reports';

  @override
  String get detailTabLabel => 'Detail';

  @override
  String get commentTabLabel => 'Comment';

  @override
  String get followupTabLabel => 'Followup';

  @override
  String get authorityNameLabel => 'Authority Name';

  @override
  String get noFollowupReport => 'No followup report';

  @override
  String get noComment => 'No comment';

  @override
  String get noGpsProvided => 'No gps location provided';

  @override
  String get zeroReportLabel => 'Zero report';

  @override
  String zeroReportLastReportedMessage(String datetime) {
    return 'Last reported at $datetime';
  }

  @override
  String get zeroReportSubmitSuccess => 'Zero report submitted';

  @override
  String get fieldUndefinedLocation => 'No location selected';

  @override
  String get fieldUseCurrentLocation => 'Use current location';

  @override
  String get authorityLabel => 'Authority';

  @override
  String get incidentDate => 'Incident Date';

  @override
  String get invalidQrcode => 'Invalid qrcode';

  @override
  String get invalidReportTypeQrcode => 'Invalid report type qrcode';

  @override
  String get invalidFormValue => 'Invalid form value';

  @override
  String get simulateReportTitle => 'Simulate report';

  @override
  String get closeSimulateReportButton => 'Close report simulation';

  @override
  String get consentButton => 'I agree';

  @override
  String get observationSubjectViewTitle => 'Subject';

  @override
  String get observationSubjectDetailTabLabel => 'Detail';

  @override
  String get observationSubjectMonitoringTabLabel => 'Monitoring';

  @override
  String get observationSubjectMonitoringViewTitle => 'Subject monitoring';

  @override
  String get validateRequiredMsg => 'This field is required';

  @override
  String dateFieldMaxErrorMsg(String max) {
    return 'must be equal or less than $max';
  }

  @override
  String dateFieldMinErrorMsg(String min) {
    return 'must be equal or more than $min';
  }

  @override
  String integerFieldMaxErrorMsg(String max) {
    return 'must be equal or less than $max';
  }

  @override
  String integerFieldMinErrorMsg(String min) {
    return 'must be equal or more than $min';
  }

  @override
  String textFieldMaxErrorMsg(String max) {
    return 'must be equal or less than $max letters';
  }

  @override
  String textFieldMinErrorMsg(String min) {
    return 'must be equal or more than $min letters';
  }

  @override
  String filesFieldMaxErrorMsg(String max) {
    return 'Number of files must be equal or less than $max';
  }

  @override
  String filesFieldMinErrorMsg(String min) {
    return 'Number of files must be equal or more than $min';
  }

  @override
  String filesFieldMaxSizeErrorMsg(String index, String maxSize) {
    return 'Size of file: #$index must be equal or less than $maxSize bytes';
  }

  @override
  String filesFieldSupportedTypeErrorMsg(String index) {
    return 'Type of file: #$index are not supported';
  }

  @override
  String get testFlag => 'Test';

  @override
  String get confirm => 'Are you sure to continue?';

  @override
  String get confirmCheckReport =>
      'This report data cannot be changed once it was submitted. Please make sure everything is correct.';

  @override
  String get submitReportMessage =>
      'Press the submit button to submit your report';

  @override
  String get reportDataSummary => 'Report data summary';

  @override
  String get reportDataSummaryNotFound =>
      'No content of summary is defined for this report type';

  @override
  String get confirmExit => 'Are you sure to continue?';

  @override
  String get incidentInAuthority =>
      'Did this incident occur in your own authority?';

  @override
  String get yesAsAccept => 'Yes';

  @override
  String get noAsReject => 'No';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get testModeOn => 'Test mode is on';

  @override
  String get loading => 'Loading...';

  @override
  String get fieldRequired => 'field is required.';

  @override
  String get passwordMismatch => 'Password does not match confirm password';

  @override
  String get restartApp => 'Application needs to be restarted.';

  @override
  String numberOfPendingSubmissions(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'submissions',
      one: 'submission',
    );
    return '$countString pending $_temp0, tap here to re-submit';
  }

  @override
  String get pendingReportsTitle => 'Reports';

  @override
  String get pendingSubjectsTitle => 'Observation records';

  @override
  String get pendingMonitoringsTitle => 'Observation monitorings';

  @override
  String get pendingImagesTitle => 'Images';

  @override
  String get pendingFilesTitle => 'Files';

  @override
  String get pendingAppLabel => 'Pending submissions';

  @override
  String get invitationCodeIsRequired => 'Invitation code is required';

  @override
  String get pickFromGallery => 'Pick from Gallery';

  @override
  String get takeAPhoto => 'Take a Photo';

  @override
  String get offlineWarning =>
      'You are offline, please check your internet connection';

  @override
  String get resubmit => 'Resubmit';

  @override
  String get noPendingSubmissions => 'There are no pending submissions.';

  @override
  String get locationServiceIsDisabled =>
      'Location service is disabled, you need to turn it on.';

  @override
  String get loadMore => 'Load more';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get welcomeSubtitle => 'Set up before signing in · ตั้งค่าก่อนเริ่ม';

  @override
  String get welcomeLanguageTitle => 'Language';

  @override
  String get welcomeLanguageSub => 'ภาษา';

  @override
  String get welcomeServerTitle => 'Server';

  @override
  String get welcomeServerSub => 'เซิร์ฟเวอร์';

  @override
  String get welcomeContinueButton => 'Continue';

  @override
  String get welcomeSavingLabel => 'Saving…';

  @override
  String get welcomeNoServersText => 'No servers available';

  @override
  String get welcomeCannotLoadServers => 'Cannot load servers';
}
