class OtpVerifyResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  OtpVerifyResponse({required this.success, required this.message, this.data});

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
