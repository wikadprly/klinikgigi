class OtpVerifyResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;
  final String? resetToken;

  OtpVerifyResponse({
    required this.success,
    required this.message,
    this.data,
    this.resetToken,
  });

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
      resetToken: json['reset_token'],
    );
  }
}
