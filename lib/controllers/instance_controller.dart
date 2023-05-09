import 'package:flutter/material.dart';
import 'package:front/model/instance_dto.dart';
import 'package:front/repositories/instance_repository.dart';

class InstanceController extends ChangeNotifier {
  final _instanceRepository = InstanceRepository();

  Future<InstanceDTO?> createInstance(
    String projectName,
    String dockerUrl,
    String username,
    String domainName,
    String token,
  ) {
    return _instanceRepository.createInstance(projectName, dockerUrl, username, domainName, token);
  }
}
