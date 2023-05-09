import 'package:flutter/cupertino.dart';
import 'package:front/constants.dart';
import 'package:front/model/gitlab/gitlab_project.dart';
import 'package:front/model/project_dto.dart';
import 'package:front/repositories/gitlab_repository.dart';
import 'package:front/repositories/project_repository.dart';
import 'package:logger/logger.dart';

class ProjectController extends ChangeNotifier {
  final _projectList = <ProjectDTO>[];
  List<ProjectDTO> get projectList => _projectList;

  final _gitlabRepository = GitlabRepository();
  final _projectRepository = ProjectRepository();

  void updateDeploymentStep(ProjectDTO projectDTO) {
    projectDTO.deploymentStep++;
    Logger().i("Upgrade step: ${projectDTO.deploymentStep}/$maxStep");
    notifyListeners();
  }

  void addProject(ProjectDTO projectDTO) {
    _projectList.add(projectDTO);
    notifyListeners();
  }

  void removeProject(ProjectDTO projectDTO) {
    _projectList.remove(projectDTO);
    notifyListeners();
  }

  Future<GitlabProject> getRepo(String projectURL) async {
    final splitProjectURL = projectURL.split(":").last.replaceAll("/", "%2F").replaceAll(".git", "");
    return await _gitlabRepository.getRepo(splitProjectURL);
  }

  Future<ProjectDTO?> createProject(ProjectDTO project, String token) async {
    return _projectRepository.createProject(project, token);
  }
}
