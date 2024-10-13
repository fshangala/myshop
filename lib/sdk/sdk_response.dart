class SdkResponse {
  String message;
  bool success;
  dynamic data;

  SdkResponse({required this.success, required this.message, this.data});
}
