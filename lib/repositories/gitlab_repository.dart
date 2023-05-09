import 'dart:convert';
import 'package:front/model/gitlab/gitlab_branche.dart';
import 'package:front/model/gitlab/gitlab_file.dart';
import 'package:front/model/gitlab/gitlab_project.dart';
import 'package:front/tools/tools.dart';
import 'package:http/http.dart' as http;

class GitlabRepository {
  Future<GitlabProject> getRepo(String splitProjectURL) async {
    List<GitlabFile> gitlabFilesList = [];
    late GitlabProject gitlabProject;

    final uri = Uri.parse('https://gitlab.com/api/v4/projects/$splitProjectURL');
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final decodedData = jsonDecode(response.body);
    gitlabProject = GitlabProject.fromJson(decodedData);

    final filesUri = Uri.parse('https://gitlab.com/api/v4/projects/${gitlabProject.id}/repository/tree?recursive=true');
    final filesResponse = await http.get(
      filesUri,
      headers: {'Content-Type': 'application/json'},
    );

    for(final jsonFile in jsonDecode(filesResponse.body)){
      gitlabFilesList.add(GitlabFile.fromJson(jsonFile));
    }

    gitlabProject.gitlabFilesList = buildTree(gitlabFilesList);
    gitlabProject.gitBranchesList = await getBranches(gitlabProject.id!);

    return gitlabProject;
  }

  Future<List<GitlabBranch>> getBranches(int projectId) async {
    final branchesList = <GitlabBranch>[];
    final branchesUri = Uri.parse('https://gitlab.com/api/v4/projects/$projectId/repository/branches');
    final branchesResponse = await http.get(
      branchesUri,
      headers: {'Content-Type': 'application/json'},
    );

    for(final jsonFile in jsonDecode(branchesResponse.body)){
      branchesList.add(GitlabBranch.fromJson(jsonFile));
    }

    return branchesList;
  }
}
