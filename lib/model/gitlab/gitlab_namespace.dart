class GitlabNamespace {
  int? id;
  String? name;
  String? path;
  String? kind;
  String? fullPath;
  String? parentId;
  String? avatarUrl;
  String? webUrl;

  GitlabNamespace(
    this.id,
    this.name,
    this.path,
    this.kind,
    this.fullPath,
    this.parentId,
    this.avatarUrl,
    this.webUrl,
  );

  factory GitlabNamespace.fromJson(Map<String, dynamic> json) {
    return GitlabNamespace(
      json['id'],
      json['name'],
      json['path'],
      json['kind'],
      json['full_path'],
      json['parent_id'],
      json['avatar_url'],
      json['web_url'],
    );
  }
}
