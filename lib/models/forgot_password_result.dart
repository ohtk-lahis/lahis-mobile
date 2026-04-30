import 'package:podd_app/models/operation_exception_failure.dart';

abstract class ForgotPasswordResult {}

class ForgotPasswordSuccess extends ForgotPasswordResult {
  bool success;
  ForgotPasswordSuccess({
    required this.success,
  });
}

class ForgotPasswordFailure extends OperationExceptionFailure
    implements ForgotPasswordResult {
  ForgotPasswordFailure(e) : super(e);
}

class ForgotPasswordInvalidData extends ForgotPasswordResult {}
