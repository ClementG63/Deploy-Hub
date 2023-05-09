import 'package:flutter/cupertino.dart';
import 'package:front/constants.dart';
import 'package:front/exceptions/register_fail_exception.dart';
import 'package:front/model/entities/user.dart';
import 'package:front/repositories/user_repository.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends ChangeNotifier {
  final _userRepository = UserRepository();

  User? _loggedUser;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  set isAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  User? get loggedUser => _loggedUser;
  set loggedUser(User? value) {
    if (value != null) {
      _loggedUser = value;
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  UserController() {
    SharedPreferences.getInstance().then((sp) {
      isAuthenticated = sp.getBool(isLoggedSPKey) ?? false;
    });
  }

  Future<void> login({
    required String mail,
    required String password,
    required bool stayConnected,
    required Function onSuccess,
    required Function onFail,
  }) async {
    final loginResult = await _userRepository.login(mail, password);
    if (loginResult.success) {
      Logger().i("LOGIN_SUCCESS");

      loggedUser = loginResult.data;
      isAuthenticated = true;

      if (stayConnected) {
        SharedPreferences.getInstance().then((sp) {
          sp.setBool(isLoggedSPKey, true);
          sp.setString(userSPKey, loggedUser!.toJson());
        });
      }
      onSuccess();
    } else {
      onFail(loginResult.message);
    }
  }

  Future<void> register({
    required String username,
    required String mail,
    required String password,
    required String firstname,
    required String lastname,
    required Function onSuccess,
    required Function(String message) onFail,
  }) async {
    try {
      final registerResult = await _userRepository.register(mail, password, username, firstname, lastname);
      if (registerResult != null) {
        Logger().i("REGISTER_SUCCESS");
        onSuccess();
      }
    } catch (e) {
      if (e is RegisterFailException) {
        Logger().e("REGISTER_ERROR: ${e.cause}");
        onFail(e.cause);
      } else {
        Logger().e("REGISTER_ERROR: $e");
        onFail(e.toString());
      }
    }
  }

  void logout() async {
    isAuthenticated = false;
    SharedPreferences.getInstance().then((sp) => sp.remove("isLogged"));
  }

  void forgotPassword() {}
}
