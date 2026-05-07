// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'OHTK Mobile';

  @override
  String get loginTitle => 'Connectez-vous à votre compte';

  @override
  String get signupTitle => 'S\'inscrire';

  @override
  String get signupSubTitle =>
      'Veuillez saisir le code d\'invitation pour l\'inscription';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get forgotPasswordSubTitle =>
      'Veuillez entrer votre adresse e-mail et nous vous enverrons un lien de réinitialisation de mot de passe';

  @override
  String get changePasswordTitle => 'Changer le mot de passe';

  @override
  String get incidentsTabTitle => 'Incidents';

  @override
  String get observationsTabTitle => 'Observations';

  @override
  String get profileTabTitle => 'Profile';

  @override
  String get caseTag => 'Case';

  @override
  String get reportTitle => 'Rapport';

  @override
  String get reportTypeTitle => 'Type de rapport';

  @override
  String get reportDetailTitle => 'Détail du rapport';

  @override
  String get followupTitle => 'Suivi';

  @override
  String get followupDetailTitle => 'Détails du suivi';

  @override
  String get profileTitle => 'Profil';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get qrCodeLoginButton => 'CONNEXION QRCode';

  @override
  String get pickQrcodeImageButton => 'Choose QRCode image';

  @override
  String get getLoginQrcodeButton => 'my QR login';

  @override
  String get logoutButton => 'Se déconnecter';

  @override
  String get registerButton => 'Registre';

  @override
  String get forgotPasswordButton => 'Mot de passe oublié';

  @override
  String get messagesPageTitle => 'Messages';

  @override
  String get messagePageTitle => 'Message';

  @override
  String get formPageLabel => 'Page';

  @override
  String get backButton => 'Dos';

  @override
  String get formBackButton => 'dos';

  @override
  String get nextButton => 'Suivant';

  @override
  String get formNextButton => 'suivant';

  @override
  String get submitButton => 'Soumettre';

  @override
  String get confirmButton => 'Confirmer';

  @override
  String get confirmRegisterButton => 'Confirmer l\'inscription';

  @override
  String get sendButton => 'Envoyer';

  @override
  String get updateProfileButton => 'Mettre à jour le profil';

  @override
  String get confirmUpdate => 'Confirmer la mise à jour';

  @override
  String get profileUpdateSuccess => 'Profil mis à jour';

  @override
  String get passwordUpdatedSuccess =>
      'Votre mot de passe a été changé avec succès!';

  @override
  String get changePasswordButton => 'Changer le mot de passe';

  @override
  String get laguageLabel => 'Langue';

  @override
  String get serverLabel => 'Serveur';

  @override
  String get usernameLabel => 'Nom d\'utilisateur';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get newPasswordLabel => 'nouveau mot de passe';

  @override
  String get confirmPasswordLabel => 'Confirmez le mot de passe';

  @override
  String get invitationCodeLabel => 'code d\'invitation';

  @override
  String get firstNameLabel => 'Prénom';

  @override
  String get lastNameLabel => 'Nom de famille';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get emailHint => 'tester@gmail.com';

  @override
  String get telephoneLabel => 'Téléphone';

  @override
  String get addressLabel => 'Address';

  @override
  String get allReportTabLabel => 'Tous les rapports';

  @override
  String get myReportTabLabel => 'Mes rapports';

  @override
  String get detailTabLabel => 'Détail';

  @override
  String get commentTabLabel => 'Commentaire';

  @override
  String get followupTabLabel => 'Suivi';

  @override
  String get authorityNameLabel => 'Nom de l\'autorité';

  @override
  String get noFollowupReport => 'Aucun rapport de suivi';

  @override
  String get noComment => 'Aucun commentaire';

  @override
  String get noGpsProvided => 'No gps location provided';

  @override
  String get zeroReportLabel => 'Zéro rapport';

  @override
  String zeroReportLastReportedMessage(String datetime) {
    return 'Signalé pour la dernière fois à $datetime';
  }

  @override
  String get zeroReportSubmitSuccess => 'Aucun rapport soumis';

  @override
  String get fieldUndefinedLocation => 'Aucun emplacement sélectionné';

  @override
  String get fieldUseCurrentLocation => 'Utiliser l\'emplacement actuel';

  @override
  String get authorityLabel => 'Autorité';

  @override
  String get incidentDate => 'Date de l\'incident';

  @override
  String get invalidQrcode => 'Invalid qrcode';

  @override
  String get invalidReportTypeQrcode => 'QRcode de type de rapport non valide';

  @override
  String get invalidFormValue => 'Valeur de formulaire invalide';

  @override
  String get simulateReportTitle => 'Simuler le rapport';

  @override
  String get closeSimulateReportButton => 'Fermer la simulation du rapport';

  @override
  String get consentButton => 'Je suis d\'accord';

  @override
  String get observationSubjectViewTitle => 'Sujet';

  @override
  String get observationSubjectDetailTabLabel => 'Détail';

  @override
  String get observationSubjectMonitoringTabLabel => 'Surveillance';

  @override
  String get observationSubjectMonitoringViewTitle => 'Surveillance du sujet';

  @override
  String get validateRequiredMsg => 'Ce champ est obligatoire';

  @override
  String dateFieldMaxErrorMsg(String max) {
    return 'doit être égal ou inférieur à $max';
  }

  @override
  String dateFieldMinErrorMsg(String min) {
    return 'doit être égal ou supérieur à $min';
  }

  @override
  String integerFieldMaxErrorMsg(String max) {
    return 'doit être égal ou inférieur à $max';
  }

  @override
  String integerFieldMinErrorMsg(String min) {
    return 'doit être égal ou supérieur à $min';
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
    return 'Le nombre doit être égal ou inférieur à $max';
  }

  @override
  String filesFieldMinErrorMsg(String min) {
    return 'Le nombre doit être égal ou supérieur à $min';
  }

  @override
  String filesFieldMaxSizeErrorMsg(String index, String maxSize) {
    return 'Taille du fichier : #$index doit être égal ou inférieur à $maxSize octets';
  }

  @override
  String filesFieldSupportedTypeErrorMsg(String index) {
    return 'Type de fichier : #$index ne sont pas pris en charge';
  }

  @override
  String get testFlag => 'Test';

  @override
  String get confirm => 'Êtes-vous sûr de continuer ?';

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
  String get confirmExit => 'Êtes-vous sûr de continuer ?';

  @override
  String get incidentInAuthority =>
      'Cet incident s\'est-il produit sous votre propre autorité ?';

  @override
  String get yesAsAccept => 'Oui';

  @override
  String get noAsReject => 'Non';

  @override
  String get ok => 'D\'ACCORD';

  @override
  String get cancel => 'Annuler';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get testModeOn => 'Le mode test est activé';

  @override
  String get loading => 'Chargement...';

  @override
  String get fieldRequired => 'Champ requis.';

  @override
  String get passwordMismatch =>
      'Le mot de passe ne correspond pas à confirmer le mot de passe';

  @override
  String get restartApp => 'L\'application doit être redémarrée.';

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

  @override
  String get signInChangeLanguageTitle => 'Language';

  @override
  String get signInChangeLanguageHint => 'Single tap applies immediately';

  @override
  String get signInChangeServerTitle => 'Switch server';

  @override
  String get signInChangeServerHint =>
      'Different countries and orgs use different servers.';

  @override
  String get signInServerCurrentBadge => 'CURRENT';

  @override
  String get signInCancelButton => 'Cancel';

  @override
  String get signInConfirmServerButton => 'Switch server';
}
