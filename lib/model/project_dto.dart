class ProjectDTO {
  String? id;
  String? name;
  late DateTime creationDate;
  DateTime? lastUpdate;
  String? repoUrl;
  List<String>? kubInstances;
  String? branch;
  String? techno;
  String? subDomain;
  late int deploymentStep;
  late String releaseName;

  ProjectDTO({
    required this.name,
    this.lastUpdate,
    required this.repoUrl,
    this.kubInstances,
    required this.branch,
    required this.techno,
    this.subDomain,
  }) {
    creationDate = DateTime.now();
    deploymentStep = 0;
  }

  factory ProjectDTO.fromJson(Map<String, dynamic> jsonDecode) {
    return ProjectDTO(
      name: jsonDecode["name"],
      repoUrl: jsonDecode["repoUrl"],
      branch: jsonDecode["branch"],
      techno: jsonDecode["techno"],
    );
  }

  ProjectDTO.empty() {
    creationDate = DateTime.now();
  }
}
