class InstanceDTO {
  String? releaseName;

  InstanceDTO({this.releaseName});

  InstanceDTO.fromJson(Map<String, dynamic> json) {
    releaseName = json['releaseName'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['releaseName'] = releaseName;
    return data;
  }
}
