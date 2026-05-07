import 'package:podd_app/models/operation_exception_failure.dart';
import 'package:podd_app/models/village.dart';

class InvitationCodeResult {}

class InvitationCodeSuccess extends InvitationCodeResult {
  String authorityName;
  String? generatedUsername;
  String? generatedEmail;
  List<Village> villages;

  InvitationCodeSuccess(
    this.authorityName,
    this.generatedUsername,
    this.generatedEmail, [
    this.villages = const [],
  ]);

  String get villageNames =>
      villages.map((village) => village.displayName).join(', ');
}

class InvitationCodeFailure extends OperationExceptionFailure
    implements InvitationCodeResult {
  InvitationCodeFailure(e) : super(e);
}
