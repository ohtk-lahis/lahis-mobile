// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'OHTK Mobile';

  @override
  String get loginTitle => 'Ingrese a su cuenta';

  @override
  String get signupTitle => 'Inscribirse';

  @override
  String get signupSubTitle =>
      'Por favor ingrese el código de invitación para registrarse';

  @override
  String get forgotPasswordTitle => 'Has olvidado tu contraseña';

  @override
  String get forgotPasswordSubTitle =>
      'Ingrese su dirección de correo electrónico y le enviaremos un enlace para restablecer su contraseña.';

  @override
  String get changePasswordTitle => 'Cambiar la contraseña';

  @override
  String get incidentsTabTitle => 'Incidents';

  @override
  String get observationsTabTitle => 'Observations';

  @override
  String get profileTabTitle => 'Profile';

  @override
  String get caseTag => 'Case';

  @override
  String get reportTitle => 'Informe';

  @override
  String get reportTypeTitle => 'Tipo de informe';

  @override
  String get reportDetailTitle => 'Detalle del informe';

  @override
  String get followupTitle => 'Hacer un seguimiento';

  @override
  String get followupDetailTitle => 'Detalle de seguimiento';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get loginButton => 'Acceso';

  @override
  String get qrCodeLoginButton => 'Código QR INICIAR SESIÓN';

  @override
  String get pickQrcodeImageButton => 'Choose QRCode image';

  @override
  String get getLoginQrcodeButton => 'my QR login';

  @override
  String get logoutButton => 'Cerrar sesión';

  @override
  String get registerButton => 'Registro';

  @override
  String get forgotPasswordButton => 'Has olvidado tu contraseña';

  @override
  String get messagesPageTitle => 'Messages';

  @override
  String get messagePageTitle => 'Message';

  @override
  String get formPageLabel => 'Page';

  @override
  String get backButton => 'Atrás';

  @override
  String get formBackButton => 'atrás';

  @override
  String get nextButton => 'Próximo';

  @override
  String get formNextButton => 'próximo';

  @override
  String get submitButton => 'Entregar';

  @override
  String get confirmButton => 'Confirmar';

  @override
  String get confirmRegisterButton => 'Confirmar Registro';

  @override
  String get sendButton => 'Enviar';

  @override
  String get updateProfileButton => 'Actualización del perfil';

  @override
  String get confirmUpdate => 'Confirmar actualización';

  @override
  String get profileUpdateSuccess => 'Perfil actualizado';

  @override
  String get passwordUpdatedSuccess =>
      '¡Su contraseña ha sido cambiada exitosamente!';

  @override
  String get changePasswordButton => 'Cambiar la contraseña';

  @override
  String get laguageLabel => 'Idioma';

  @override
  String get serverLabel => 'Servidor';

  @override
  String get usernameLabel => 'Nombre de usuario';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get newPasswordLabel => 'Nueva contraseña';

  @override
  String get confirmPasswordLabel => 'Confirmar Contraseña';

  @override
  String get invitationCodeLabel => 'código de invitación';

  @override
  String get firstNameLabel => 'Nombre de pila';

  @override
  String get lastNameLabel => 'Apellido';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailHint => 'tester@gmail.com';

  @override
  String get telephoneLabel => 'Teléfono';

  @override
  String get addressLabel => 'Address';

  @override
  String get allReportTabLabel => 'Todos los informes';

  @override
  String get myReportTabLabel => 'Mis informes';

  @override
  String get detailTabLabel => 'Detalle';

  @override
  String get commentTabLabel => 'Comentario';

  @override
  String get followupTabLabel => 'Hacer un seguimiento';

  @override
  String get authorityNameLabel => 'Nombre de la autoridad';

  @override
  String get noFollowupReport => 'Sin informe de seguimiento';

  @override
  String get noComment => 'Sin comentarios';

  @override
  String get noGpsProvided => 'No gps location provided';

  @override
  String get zeroReportLabel => 'Informe cero';

  @override
  String zeroReportLastReportedMessage(String datetime) {
    return 'Reportado por última vez el $datetime';
  }

  @override
  String get zeroReportSubmitSuccess => 'Informe cero enviado';

  @override
  String get fieldUndefinedLocation => 'Ninguna ubicación seleccionada';

  @override
  String get fieldUseCurrentLocation => 'Usar ubicación actual';

  @override
  String get authorityLabel => 'Autoridad';

  @override
  String get incidentDate => 'Fecha del incidente';

  @override
  String get invalidQrcode => 'Invalid qrcode';

  @override
  String get invalidReportTypeQrcode =>
      'Código QR de tipo de informe no válido';

  @override
  String get invalidFormValue => 'Valor de formulario no válido';

  @override
  String get simulateReportTitle => 'Simular informe';

  @override
  String get closeSimulateReportButton => 'Cerrar simulación de informe';

  @override
  String get consentButton => 'Estoy de acuerdo';

  @override
  String get observationSubjectViewTitle => 'Sujeto';

  @override
  String get observationSubjectDetailTabLabel => 'Detalle';

  @override
  String get observationSubjectMonitoringTabLabel => 'Supervisión';

  @override
  String get observationSubjectMonitoringViewTitle => 'Seguimiento de sujetos';

  @override
  String get validateRequiredMsg => 'Este campo es obligatorio';

  @override
  String dateFieldMaxErrorMsg(String max) {
    return 'debe ser igual o menor que $max';
  }

  @override
  String dateFieldMinErrorMsg(String min) {
    return 'debe ser igual o mayor que $min';
  }

  @override
  String integerFieldMaxErrorMsg(String max) {
    return 'debe ser igual o menor que $max';
  }

  @override
  String integerFieldMinErrorMsg(String min) {
    return 'debe ser igual o mayor que $min';
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
    return 'El número de archivos debe ser igual o menor que $max';
  }

  @override
  String filesFieldMinErrorMsg(String min) {
    return 'El número de archivos debe ser igual o mayor que $min';
  }

  @override
  String filesFieldMaxSizeErrorMsg(String index, String maxSize) {
    return 'Tamaño del archivo: #$index debe ser igual o menor que $maxSize bytes';
  }

  @override
  String filesFieldSupportedTypeErrorMsg(String index) {
    return 'Tipo de archivo: #$index no son compatibles';
  }

  @override
  String get testFlag => 'Test';

  @override
  String get confirm => '¿Estás seguro de continuar?';

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
  String get confirmExit => '¿Estás seguro de continuar?';

  @override
  String get incidentInAuthority =>
      '¿Este incidente ocurrió bajo su propia autoridad?';

  @override
  String get yesAsAccept => 'Sí';

  @override
  String get noAsReject => 'No';

  @override
  String get ok => 'DE ACUERDO';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get testModeOn => 'El modo de prueba está activado.';

  @override
  String get loading => 'Cargando...';

  @override
  String get fieldRequired => 'Se requiere campo.';

  @override
  String get passwordMismatch =>
      'La contraseña no coincide. Confirmar contraseña.';

  @override
  String get restartApp => 'Es necesario reiniciar la aplicación.';

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
  String get welcomeSubtitle => 'Set up before signing in';

  @override
  String get welcomeLanguageTitle => 'Language';

  @override
  String get welcomeServerTitle => 'Server';

  @override
  String get welcomeContinueButton => 'Continue';

  @override
  String get welcomeSavingLabel => 'Saving…';

  @override
  String get welcomeNoServersText => 'No servers available';

  @override
  String get welcomeCannotLoadServers => 'Cannot load servers';

  @override
  String get signInRegisterCta => 'Register as reporter';

  @override
  String get signInButton => 'Sign in';

  @override
  String get signInQrCodeButton => 'QRCode Sign In';

  @override
  String get signInReturningEyebrow => 'Returning reporter';

  @override
  String get signInServerLabel => 'Server';

  @override
  String get signInChangeServerButton => 'Change';
}
