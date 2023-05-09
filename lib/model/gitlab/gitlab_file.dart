import 'package:front/exceptions/not_folder_exception.dart';
import 'package:front/model/gitlab/gitlab_file_type.dart';

class GitlabFile {
  String id, name, path;
  GitlabFileType type;

  List<GitlabFile>? _children;
  List<GitlabFile>? get children => _children;

  void addChild(GitlabFile glb){
    if(type == GitlabFileType.folder){
      if(children == null){
        _children = [];
      }
      _children!.add(glb);
    } else {
      throw NotFolderException("You can't add child to a FILE");
    }
  }

  GitlabFile(
    this.id,
    this.name,
    this.type,
    this.path,
  );

  factory GitlabFile.fromJson(Map<String, dynamic> jsonFile) {
    return GitlabFile(
      jsonFile["id"],
      jsonFile["name"],
      jsonFile["type"] == "tree" ? GitlabFileType.folder : GitlabFileType.file,
      jsonFile["path"],
    );
  }
}
