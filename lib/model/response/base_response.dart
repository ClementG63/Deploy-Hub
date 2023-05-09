class BaseResponse<T> {
  late bool success;
  late int code;
  late String message;
  late String details;
  late T? data;

  BaseResponse(
    this.success,
    this.code,
    this.message,
    this.details,
    this.data,
  );

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    final data = json["data"];
    return BaseResponse(
      json["success"],
      json["code"],
      json["message"],
      json["details"],
      data != null ? fromJson(data) : null,
    );
  }
}
