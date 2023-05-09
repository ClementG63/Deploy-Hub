import 'package:front/exceptions/custom_exception.dart';

class LoginFailException extends CustomException {
  LoginFailException(super.cause);
}