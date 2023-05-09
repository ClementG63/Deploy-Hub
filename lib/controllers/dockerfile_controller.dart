import 'package:flutter/material.dart';
import 'package:front/repositories/dockerfile_repository.dart';

class DockerfileController extends ChangeNotifier {
  final _dockerfileRepository = DockerfileRepository();

  //TODO modifier type de retour
  Future<String?>? createDockerfile(String templateId, String gitUrl, String token) {
    return _dockerfileRepository.createDockerfile(templateId, gitUrl, token);
  }
}
