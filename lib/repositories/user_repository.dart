import 'dart:convert';

import 'package:front/constants.dart';
import 'package:front/data/api_helper.dart';
import 'package:front/exceptions/register_fail_exception.dart';
import 'package:front/model/entities/user.dart';
import 'package:front/model/response/base_response.dart';

class UserRepository {
  final _authEndpoint = "$apiAddress/auth";

  Future<User?> register(
    String mail,
    String password,
    String username,
    String firstname,
    String lastname,
  ) async {
    final response = await ApiHelper.post(
      url: "$_authEndpoint/public/register",
      body: {
        "email": mail,
        "firstname": firstname,
        "lastname": lastname,
        "password": password,
        "username": username,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body)["response"]["data"]);
    }
    throw RegisterFailException(jsonEncode(response.body));
  }

  Future<BaseResponse<User?>> login(String mail, String password) async {
    final response = await ApiHelper.post(
      url: "$_authEndpoint/public/login",
      body: {
        "email": mail.toLowerCase(),
        "password": password,
      },
    );
    return BaseResponse.fromJson(jsonDecode(response.body)["response"], (user) => User.fromJson(user));
  }
}
