class DockerfileDTO {
  String? url;

  DockerfileDTO(this.url);
  factory DockerfileDTO.fromJson(Map<String, dynamic> json) {
    return DockerfileDTO(json["url"]);
  }
}
