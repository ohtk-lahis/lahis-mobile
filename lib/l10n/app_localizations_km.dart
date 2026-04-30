// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Khmer Central Khmer (`km`).
class AppLocalizationsKm extends AppLocalizations {
  AppLocalizationsKm([String locale = 'km']) : super(locale);

  @override
  String get appName => 'OHTK Mobile';

  @override
  String get loginTitle => 'ចូលទៅគណនីរបស់អ្នក។';

  @override
  String get signupTitle => 'ចុះ​ឈ្មោះ';

  @override
  String get signupSubTitle => 'Please enter Invitation Code\nfor registration';

  @override
  String get forgotPasswordTitle => 'ភ្លេច​លេខសំងាត់​';

  @override
  String get forgotPasswordSubTitle =>
      'Please enter your email address to receive messages for editing password';

  @override
  String get changePasswordTitle => 'ផ្លាស់ប្តូរពាក្យសម្ងាត់';

  @override
  String get incidentsTabTitle => 'Incidents';

  @override
  String get observationsTabTitle => 'Observations';

  @override
  String get profileTabTitle => 'Profile';

  @override
  String get caseTag => 'Case';

  @override
  String get reportTitle => 'រាយការណ៍';

  @override
  String get reportTypeTitle => 'ប្រភេទ​នៃ​របាយការណ៍';

  @override
  String get reportDetailTitle => 'រាយការណ៍លម្អិត';

  @override
  String get followupTitle => 'តាមដាន';

  @override
  String get followupDetailTitle => 'ព័ត៌មានលម្អិតតាមដាន';

  @override
  String get profileTitle => 'Profile';

  @override
  String get loginButton => 'ចូល';

  @override
  String get qrCodeLoginButton => 'QRCode LOGIN';

  @override
  String get pickQrcodeImageButton => 'Choose QRCode image';

  @override
  String get getLoginQrcodeButton => 'my QR login';

  @override
  String get logoutButton => 'Logout';

  @override
  String get registerButton => 'ចុះឈ្មោះ';

  @override
  String get forgotPasswordButton => 'ភ្លេច​លេខសំងាត់​';

  @override
  String get messagesPageTitle => 'Messages';

  @override
  String get messagePageTitle => 'Message';

  @override
  String get formPageLabel => 'Page';

  @override
  String get backButton => 'ត្រឡប់មកវិញ';

  @override
  String get formBackButton => 'back';

  @override
  String get nextButton => 'បន្ទាប់';

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
  String get laguageLabel => 'ភាសា';

  @override
  String get serverLabel => 'ម៉ាស៊ីនមេ';

  @override
  String get usernameLabel => 'ឈ្មោះ​អ្នកប្រើប្រាស់';

  @override
  String get passwordLabel => 'ពាក្យសម្ងាត់';

  @override
  String get newPasswordLabel => 'ពាក្យសម្ងាត់';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get invitationCodeLabel => 'លេខ​កូដ​ការ​អញ្ជើញ';

  @override
  String get firstNameLabel => 'ឈ្មោះដំបូង';

  @override
  String get lastNameLabel => 'នាមត្រកូល';

  @override
  String get emailLabel => 'អ៊ីមែល';

  @override
  String get emailHint => 'tester@gmail.com';

  @override
  String get telephoneLabel => 'ទូរស័ព្ទ';

  @override
  String get addressLabel => 'Address';

  @override
  String get allReportTabLabel => 'របាយការណ៍ទាំងអស់។';

  @override
  String get myReportTabLabel => 'របាយការណ៍របស់ខ្ញុំ';

  @override
  String get detailTabLabel => 'លម្អិត';

  @override
  String get commentTabLabel => 'មតិយោបល់';

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
  String get zeroReportLabel =>
      'របាយការណ៍​មិន​បាន​រក​ឃើញ​អ្វី​ខុស​ប្រក្រតី​ទេ។';

  @override
  String zeroReportLastReportedMessage(String datetime) {
    return 'រាយការណ៍ចុងក្រោយនៅ $datetime';
  }

  @override
  String get zeroReportSubmitSuccess => 'បានផ្ញើរបាយការណ៍ដោយជោគជ័យ';

  @override
  String get fieldUndefinedLocation => 'មិនបានជ្រើសរើសទីតាំងទេ។';

  @override
  String get fieldUseCurrentLocation => 'ប្រើទីតាំងបច្ចុប្បន្ន';

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
}
