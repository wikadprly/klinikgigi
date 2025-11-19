class OtpVerifyResponse {
  final bool success;
  final String message;
<<<<<<< HEAD
  final Map<String, dynamic>? data;

  OtpVerifyResponse({required this.success, required this.message, this.data});

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
=======
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
>>>>>>> Jeffrey
    );
  }
}
