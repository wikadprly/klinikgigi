class UserData {
  final String userId;
  final String namaPengguna;
  final String email;
  final String token;
  final int? tokenExpiresIn;

  UserData({
    required this.userId,
    required this.namaPengguna,
    required this.email,
    required this.token,
    this.tokenExpiresIn,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json["user_id"],
      namaPengguna: json["nama_pengguna"],
      email: json["email"],
      token: json["token"],
      tokenExpiresIn: json["token_expires_in"],
    );
  }
}
