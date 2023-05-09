import 'dart:convert';

import 'package:front/constants.dart';
import 'package:front/data/api_helper.dart';
import 'package:front/model/project_dto.dart';
import 'package:logger/logger.dart';

class ProjectRepository {
  Future<ProjectDTO?> createProject(ProjectDTO project, String token) async {
    const projectEndpoint = "$apiAddress/projects";

    //TODO MODIFIER CONDITION QUAND API A JOUR
    if (true) {
      return project;
    }

    final response = await ApiHelper.post(
      url: "$projectEndpoint/",
      token: token,
      body: {
        "projectTitle": project.name,
        "gitUrl": project.repoUrl,
        "branch": project.branch,
        "techno": project.techno,
        "kubeInstances": [],
        "users": [],
        "subDomain": project.subDomain ?? "",
      },
    ).timeout(
      const Duration(minutes: 1),
      onTimeout: () {
        Logger().e("THIS TIMEOUT");
        return Future.value(null);
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProjectDTO.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
