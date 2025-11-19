class OtpRequestResponse {
  final bool success;
  final String message;

  OtpRequestResponse({required this.success, required this.message});

  factory OtpRequestResponse.fromJson(Map<String, dynamic> json) {
    return OtpRequestResponse(
      success: json["success"],
      message: json["message"],
    );
  }
}
