import 'dart:convert';

import 'package:front/constants.dart';
import 'package:front/data/api_helper.dart';
import 'package:front/exceptions/dockerfile_creation_exception.dart';
import 'package:front/model/dockerfile_dto.dart';
import 'package:front/model/response/base_response.dart';

class DockerfileRepository {
  Future<String?> createDockerfile(String templateId, String gitUrl, String token) async {
    const dockerfileEndpoint = "$apiAddress/dockerfile/public/build";

    final response = await ApiHelper.post(
      url: "$dockerfileEndpoint/",
      token: token,
      body: {
        "templateId": templateId,
        "contextUrl": gitUrl,
      },
    ).timeout(
      const Duration(minutes: 5),
      onTimeout: () {
        throw DockerfileCreationException("Impossible d'atteindre l'API pour la récupération du Dockerfile");
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return BaseResponse<DockerfileDTO>.fromJson(
        jsonDecode(response.body)["response"],
        (data) => DockerfileDTO.fromJson(data),
      ).message;
    }

    throw DockerfileCreationException("Impossible de récupérer l'adresse du Dockerfile");
  }
}
