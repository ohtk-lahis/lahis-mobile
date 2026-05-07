// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'OHTK Mobile';

  @override
  String get loginTitle => 'ลงชื่อเข้าใช้บัญชีของคุณ';

  @override
  String get signupTitle => 'ลงทะเบียนผ่าน Code';

  @override
  String get signupSubTitle => 'กรุณากรอก Invitation Code\nสำหรับใช้ลงทะเบียน';

  @override
  String get forgotPasswordTitle => 'ลืมรหัสผ่าน';

  @override
  String get forgotPasswordSubTitle =>
      'กรุณาระบุอีเมลเพื่อรับข้อความ\nสำหรับแก้ไขรหัสผ่าน';

  @override
  String get changePasswordTitle => 'เปลี่ยนรหัสผ่าน';

  @override
  String get incidentsTabTitle => 'รายงาน';

  @override
  String get observationsTabTitle => 'สังเกตุการณ์';

  @override
  String get profileTabTitle => 'ผู้ใช้';

  @override
  String get caseTag => 'Case';

  @override
  String get reportTitle => 'รายงาน';

  @override
  String get reportTypeTitle => 'ประเภทรายงาน';

  @override
  String get reportDetailTitle => 'รายละเอียดรายงาน';

  @override
  String get followupTitle => 'ติดตาม';

  @override
  String get followupDetailTitle => 'รายละเอียดการติดตาม';

  @override
  String get profileTitle => 'แก้ไขโปรไฟล์';

  @override
  String get loginButton => 'เข้าสู่ระบบ';

  @override
  String get qrCodeLoginButton => 'เข้าสู่ระบบผ่าน QR Code';

  @override
  String get pickQrcodeImageButton => 'เลือกรูป QR Code';

  @override
  String get getLoginQrcodeButton => 'QR ของฉันเพื่อใช้เข้าสู่ระบบ';

  @override
  String get logoutButton => 'ออกจากระบบ';

  @override
  String get registerButton => 'ลงทะเบียนผ่าน Code';

  @override
  String get forgotPasswordButton => 'ลืมรหัสผ่าน';

  @override
  String get messagesPageTitle => 'Messages';

  @override
  String get messagePageTitle => 'Message';

  @override
  String get formPageLabel => 'Page';

  @override
  String get backButton => 'Back';

  @override
  String get formBackButton => 'ย้อนกลับ';

  @override
  String get nextButton => 'ไปขั้นตอนต่อไป';

  @override
  String get formNextButton => 'ต่อไป';

  @override
  String get submitButton => 'บันทึก';

  @override
  String get confirmButton => 'ยืนยัน';

  @override
  String get confirmRegisterButton => 'ยืนยันลงทะเบียน';

  @override
  String get sendButton => 'ส่ง';

  @override
  String get updateProfileButton => 'แก้ไขโปรไฟล์';

  @override
  String get confirmUpdate => 'ยืนยันการแก้ไข';

  @override
  String get profileUpdateSuccess => 'แก้ไขโปรไฟล์สำเร็จ';

  @override
  String get passwordUpdatedSuccess =>
      'Your password has been successfully changed!';

  @override
  String get changePasswordButton => 'แก้ไขรหัสผ่าน';

  @override
  String get laguageLabel => 'ภาษา';

  @override
  String get serverLabel => 'เซิร์ฟเวอร์';

  @override
  String get usernameLabel => 'ชื่อผู้ใช้';

  @override
  String get passwordLabel => 'รหัสผ่าน';

  @override
  String get newPasswordLabel => 'รหัสผ่านใหม่';

  @override
  String get confirmPasswordLabel => 'ยืนยันรหัสผ่าน';

  @override
  String get invitationCodeLabel => 'กรอกรหัสสำหรับลงทะเบียน';

  @override
  String get firstNameLabel => 'ชื่อจริง';

  @override
  String get lastNameLabel => 'นามสกุล';

  @override
  String get emailLabel => 'อีเมล';

  @override
  String get emailHint => 'tester@gmail.com';

  @override
  String get telephoneLabel => 'โทรศัพท์';

  @override
  String get addressLabel => 'ที่อยู่';

  @override
  String get allReportTabLabel => 'รายงานทั้งหมด';

  @override
  String get myReportTabLabel => 'รายงานของฉัน';

  @override
  String get detailTabLabel => 'รายละเอียด';

  @override
  String get commentTabLabel => 'ความคิดเห็น';

  @override
  String get followupTabLabel => 'การติดตาม';

  @override
  String get authorityNameLabel => 'หน่วยงาน';

  @override
  String get noFollowupReport => 'ไม่มีรายงานการติดตาม';

  @override
  String get noComment => 'ไม่มีความคิดเห็น';

  @override
  String get noGpsProvided => 'ไม่ได้ระบุสถานที่ gps';

  @override
  String get zeroReportLabel => 'รายงานไม่พบเหตุผิดปกติ';

  @override
  String zeroReportLastReportedMessage(String datetime) {
    return 'รายงานครั้งสุดท้ายเมื่อวันที่ $datetime';
  }

  @override
  String get zeroReportSubmitSuccess => 'ส่งรายงานไม่พบเหตุผิดปกติสำเร็จ';

  @override
  String get fieldUndefinedLocation => 'ยังไม่ระบุพิกัด';

  @override
  String get fieldUseCurrentLocation => 'ใช้ตำแหน่งปัจจุบัน';

  @override
  String get authorityLabel => 'หน่วยงาน';

  @override
  String get incidentDate => 'วันที่เกิดเหตุ';

  @override
  String get invalidQrcode => 'qrcode ไม่ถูกต้อง';

  @override
  String get invalidReportTypeQrcode => 'qrcode ไม่ถูกต้องสำหรับประเภทรายงาน';

  @override
  String get invalidFormValue => 'ค่าที่ป้อนไม่ถูกต้อง';

  @override
  String get simulateReportTitle => 'จำลองแบบรายงาน';

  @override
  String get closeSimulateReportButton => 'ปิดการจำลองรายงาน';

  @override
  String get consentButton => 'ยินยอม';

  @override
  String get observationSubjectViewTitle => 'หัวเรื่อง';

  @override
  String get observationSubjectDetailTabLabel => 'รายละเอียด';

  @override
  String get observationSubjectMonitoringTabLabel => 'การเฝ้าดูติดตาม';

  @override
  String get observationSubjectMonitoringViewTitle =>
      'หัวเรื่องการเฝ้าดูติดตาม';

  @override
  String get validateRequiredMsg => 'กรุณาระบุค่า';

  @override
  String dateFieldMaxErrorMsg(String max) {
    return 'ต้องน้อยกว่า $max';
  }

  @override
  String dateFieldMinErrorMsg(String min) {
    return 'ต้องมากกว่า $min';
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
    return 'Number of files must be equal or lesser than $max';
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
  String get testFlag => 'ทดสอบ';

  @override
  String get confirm => 'ต้องการออกจากหน้ารายงานหรือไม่';

  @override
  String get confirmCheckReport =>
      'รายงานที่ส่งแล้วจะไม่สามารถแก้ไขได้อีก กรุณาตรวจสอบความถูกต้องของข้อมูลก่อนส่ง';

  @override
  String get submitReportMessage => 'กดปุ่มบันทึกเพื่อส่งรายงาน';

  @override
  String get reportDataSummary => 'สรุปรายงาน';

  @override
  String get reportDataSummaryNotFound =>
      'ไม่พบเนื้อหาการสรุปสำหรับประเภทรายงานนี้';

  @override
  String get confirmExit => 'ต้องการออกจากหน้าจอหรือไม่';

  @override
  String get incidentInAuthority =>
      'พื้นที่เกิดเหตุอยู่ในหน่วยงานสังกัดของท่านหรือไม่';

  @override
  String get yesAsAccept => 'ใช่';

  @override
  String get noAsReject => 'ไม่ใช่';

  @override
  String get ok => 'ตกลง';

  @override
  String get cancel => 'Cancel';

  @override
  String get yes => 'ตกลง';

  @override
  String get no => 'ยกเลิก';

  @override
  String get testModeOn => 'กำลังเปิดใช้งานโหมดทดสอบ';

  @override
  String get loading => 'Loading...';

  @override
  String get fieldRequired => 'กรุณากรอกข้อมูล';

  @override
  String get passwordMismatch => 'รหัสผ่านไม่ถูกต้อง';

  @override
  String get restartApp => 'แอปพลิเคชันจะทำการรีสตาร์ท';

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
  String get loadMore => 'ดูเพิ่มเติม';

  @override
  String get welcomeTitle => 'ยินดีต้อนรับ';

  @override
  String get welcomeSubtitle => 'ตั้งค่าก่อนเริ่ม';

  @override
  String get welcomeLanguageTitle => 'ภาษา';

  @override
  String get welcomeServerTitle => 'เซิร์ฟเวอร์';

  @override
  String get welcomeContinueButton => 'ดำเนินการต่อ';

  @override
  String get welcomeSavingLabel => 'กำลังบันทึก…';

  @override
  String get welcomeNoServersText => 'ไม่มีเซิร์ฟเวอร์ให้เลือก';

  @override
  String get welcomeCannotLoadServers => 'โหลดข้อมูลเซิร์ฟเวอร์ไม่สำเร็จ';

  @override
  String get signInRegisterCta => 'ลงทะเบียนเป็นผู้รายงาน';

  @override
  String get signInButton => 'เข้าสู่ระบบ';

  @override
  String get signInQrCodeButton => 'เข้าระบบด้วย QRCode';

  @override
  String get signInReturningEyebrow => 'ผู้รายงานเดิม';

  @override
  String get signInServerLabel => 'เซิร์ฟเวอร์';

  @override
  String get signInChangeServerButton => 'เปลี่ยน';

  @override
  String get signInChangeLanguageTitle => 'ภาษา';

  @override
  String get signInChangeLanguageHint => 'แตะเพื่อใช้งานทันที';

  @override
  String get signInChangeServerTitle => 'เปลี่ยนเซิร์ฟเวอร์';

  @override
  String get signInChangeServerHint =>
      'ประเทศและองค์กรต่าง ๆ ใช้เซิร์ฟเวอร์ต่างกัน';

  @override
  String get signInServerCurrentBadge => 'ปัจจุบัน';

  @override
  String get signInCancelButton => 'ยกเลิก';

  @override
  String get signInConfirmServerButton => 'เปลี่ยนเซิร์ฟเวอร์';

  @override
  String get registerTitle => 'ลงทะเบียนผู้รายงาน';

  @override
  String get registerStep1Eyebrow => 'ขั้นตอนที่ 1 จาก 2';

  @override
  String get registerStep2Eyebrow => 'ขั้นตอนที่ 2 จาก 2';

  @override
  String get registerCodeTitle => 'กรอกรหัสเชิญ';

  @override
  String get registerCodeSubtitle => 'ผู้ประสานงานอบรมจะให้รหัส 7 หลักกับคุณ';

  @override
  String get registerCodeError => 'รหัสไม่ถูกต้อง โปรดติดต่อผู้ประสานงาน';

  @override
  String get registerCodeChecking => 'กำลังตรวจสอบรหัส…';

  @override
  String get registerCodeContinue => 'ถัดไป';

  @override
  String get registerCodeContinueChecking => 'กำลังตรวจสอบ…';

  @override
  String get registerCodeHelp => 'ยังไม่มีรหัส?';

  @override
  String get registerCodeHelpLink => 'ติดต่อผู้ประสานงาน';

  @override
  String get registerCodeAccepted => 'รหัสถูกต้อง';

  @override
  String get registerVillageLabel => 'หมู่บ้าน';

  @override
  String get registerUsernameHint =>
      'ระบบสร้างให้แล้ว แก้ไขได้ตอนนี้เท่านั้น ภายหลังจะแก้ไม่ได้';

  @override
  String get registerFirstNamePlaceholder => 'ชื่อจริง';

  @override
  String get registerLastNamePlaceholder => 'นามสกุล';

  @override
  String get registerPhonePlaceholder => '08x-xxx-xxxx';

  @override
  String get registerEmailHint =>
      'ระบบสร้างอีเมลให้ แตะเพื่อใส่อีเมลจริงของคุณถ้ามี';

  @override
  String get registerAddressPlaceholder => 'บ้านเลขที่ ถนน';

  @override
  String get registerOptional => 'ไม่บังคับ';

  @override
  String get registerAuto => 'อัตโนมัติ';

  @override
  String get registerNoPasswordInfo =>
      'ยังไม่ต้องตั้งรหัสผ่าน ตั้งภายหลังได้ที่หน้าตั้งค่า';

  @override
  String get registerSubmit => 'สร้างบัญชีและเข้าระบบ';

  @override
  String get registerCreating => 'กำลังสร้างบัญชี…';
}
