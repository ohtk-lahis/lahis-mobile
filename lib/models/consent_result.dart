import 'package:podd_app/models/operation_exception_failure.dart';

class ConsentSubmitResult {}

class ConsentSubmitSuccess extends ConsentSubmitResult {
  ConsentSubmitSuccess();
}

class ConsentSubmitFailure extends OperationExceptionFailure
    implements ConsentSubmitResult {
  ConsentSubmitFailure(e) : super(e);
}
