class OtpVerifyResponse {
  final bool success;
  final String message;
  final String? resetToken;

  OtpVerifyResponse({
    required this.success,
    required this.message,
    this.resetToken,
  });

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(
      success: json['success'],
      message: json['message'],
      resetToken: json['reset_token'],
    );
  }
}
