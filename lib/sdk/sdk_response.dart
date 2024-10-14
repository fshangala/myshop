class SdkResponse<T> {
  String message;
  bool success;
  T? data;

  SdkResponse({required this.success, required this.message, this.data});
}
