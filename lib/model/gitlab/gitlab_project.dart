import 'package:front/model/gitlab/gitlab_branche.dart';
import 'package:front/model/gitlab/gitlab_file.dart';
import 'package:front/model/gitlab/gitlab_namespace.dart';

class GitlabProject {
  List<GitlabFile> gitlabFilesList = [];
  List<GitlabBranch> gitBranchesList = [];
  int? id;
  String? description;
  String? name;
  String? nameWithNamespace;
  String? path;
  String? pathWithNamespace;
  String? createdAt;
  String? defaultBranch;
  String? sshUrlToRepo;
  String? httpUrlToRepo;
  String? webUrl;
  String? readmeUrl;
  String? avatarUrl;
  int? forksCount;
  int? starCount;
  String? lastActivityAt;
  GitlabNamespace? namespace;

  GitlabProject({
    this.id,
    this.description,
    this.name,
    this.nameWithNamespace,
    this.path,
    this.pathWithNamespace,
    this.createdAt,
    this.defaultBranch,
    this.sshUrlToRepo,
    this.httpUrlToRepo,
    this.webUrl,
    this.readmeUrl,
    this.avatarUrl,
    this.forksCount,
    this.starCount,
    this.lastActivityAt,
    this.namespace,
  });

  GitlabProject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    name = json['name'];
    nameWithNamespace = json['name_with_namespace'];
    path = json['path'];
    pathWithNamespace = json['path_with_namespace'];
    createdAt = json['created_at'];
    defaultBranch = json['default_branch'];
    sshUrlToRepo = json['ssh_url_to_repo'];
    httpUrlToRepo = json['http_url_to_repo'];
    webUrl = json['web_url'];
    readmeUrl = json['readme_url'];
    avatarUrl = json['avatar_url'];
    forksCount = json['forks_count'];
    starCount = json['star_count'];
    lastActivityAt = json['last_activity_at'];
    namespace = json['namespace'] != null ? GitlabNamespace.fromJson(json['namespace']) : null;
  }
}

