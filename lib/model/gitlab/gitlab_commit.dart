class GitlabCommit {
  String? id;
  String? shortId;
  String? createdAt;
  List<String>? parentIds;
  String? title;
  String? message;
  String? authorName;
  String? authorEmail;
  String? authoredDate;
  String? committerName;
  String? committerEmail;
  String? committedDate;
  String? webUrl;

  GitlabCommit({
    this.id,
    this.shortId,
    this.createdAt,
    this.parentIds,
    this.title,
    this.message,
    this.authorName,
    this.authorEmail,
    this.authoredDate,
    this.committerName,
    this.committerEmail,
    this.committedDate,
    this.webUrl,
  });

  GitlabCommit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortId = json['short_id'];
    createdAt = json['created_at'];
    parentIds = json['parent_ids'].cast<String>();
    title = json['title'];
    message = json['message'];
    authorName = json['author_name'];
    authorEmail = json['author_email'];
    authoredDate = json['authored_date'];
    committerName = json['committer_name'];
    committerEmail = json['committer_email'];
    committedDate = json['committed_date'];
    webUrl = json['web_url'];
  }
}
