
import 'package:front/model/gitlab/gitlab_commit.dart';

class GitlabBranch {
  String? name;
  GitlabCommit? commit;
  bool? merged;
  bool? protected;
  bool? developersCanPush;
  bool? developersCanMerge;
  bool? canPush;
  String? webUrl;

  GitlabBranch({
    this.name,
    this.commit,
    this.merged,
    this.protected,
    this.developersCanPush,
    this.developersCanMerge,
    this.canPush,
    this.webUrl,
  });

  GitlabBranch.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    commit = json['commit'] != null ? GitlabCommit.fromJson(json['commit']) : null;
    merged = json['merged'];
    protected = json['protected'];
    developersCanPush = json['developers_can_push'];
    developersCanMerge = json['developers_can_merge'];
    canPush = json['can_push'];
    webUrl = json['web_url'];
  }
}