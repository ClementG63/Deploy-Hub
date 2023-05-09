import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiHelper {
  static Future<http.Response> post({
    required String url,
    String? token,
    required Map<String, dynamic> body,
  }) async {
    final parsedURL = Uri.parse(url);

    return http.post(
      parsedURL,
      headers: <String, String>{
        if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
  }
}
