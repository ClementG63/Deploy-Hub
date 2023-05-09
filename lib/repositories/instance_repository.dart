import 'dart:convert';

import 'package:front/constants.dart';
import 'package:front/data/api_helper.dart';
import 'package:front/exceptions/instance_creation_exception.dart';
import 'package:front/model/instance_dto.dart';
import 'package:front/model/response/base_response.dart';

class InstanceRepository {
  Future<InstanceDTO?> createInstance(
    String projectName,
    String dockerUrl,
    String username,
    String domainName,
    String token,
  ) async {
    const instanceEndpoint = "$apiAddress/instance/protected/release";

    final response = await ApiHelper.post(
      url: "$instanceEndpoint/",
      token: token,
      body: {
        "username": username,
        "projectName": projectName,
        "values": ["image=$dockerUrl", "ingress.host.name=$domainName"],
      },
    ).timeout(
      const Duration(minutes: 5),
      onTimeout: () {
        throw InstanceCreationException("Impossible d'atteindre l'API pour la création de l'instance");
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return BaseResponse<InstanceDTO>.fromJson(
          jsonDecode(response.body)["response"], (data) => InstanceDTO.fromJson(data)).data;
    }

    throw InstanceCreationException("Impossible de créer l'instance (Etape 2)");
  }
}
