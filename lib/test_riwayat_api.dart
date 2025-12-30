import 'dart:convert';
import 'package:http/http.dart' as http;
import 'core/storage/shared_prefs_helper.dart';

/// File ini untuk testing API riwayat
/// Jalankan dari main.dart untuk debugging

void main() async {
  // Test 1: Ambil user dari SharedPrefs
  print('\n========== TEST 1: GET USER FROM SHAREDPREFS ==========');
  final user = await SharedPrefsHelper.getUser();

  if (user == null) {
    print('❌ User NULL - Silakan login dulu');
    return;
  }

  print('✅ User ditemukan:');
  print('  - User ID: ${user.userId}');
  print('  - Nama: ${user.namaPengguna}');
  print('  - Email: ${user.email}');
  print('  - Rekam Medis ID: ${user.rekamMedisId}');
  // Token disimpan terpisah di SharedPrefs (key: auth_token)
  final tokenFromPrefs = await SharedPrefsHelper.getToken();
  print(
    '  - Token (stored): ${tokenFromPrefs != null ? '${tokenFromPrefs.substring(0, 20)}...' : 'NULL'}',
  );

  // Test 2: Call API Riwayat
  print('\n========== TEST 2: CALL API RIWAYAT ==========');

  final token = tokenFromPrefs;
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/api/riwayat'),
    headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
  );

  print('Status Code: ${response.statusCode}');
  print('Response Body:');
  print(response.body);

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    print('\n========== TEST 3: PARSE RESPONSE ==========');
    print('Decoded Response:');
    print(jsonEncode(decoded));

    if (decoded is Map) {
      print('\nResponse is Map');
      print('Keys: ${decoded.keys.toList()}');
      final data = decoded["data"] ?? [];
      print('Data count: ${data.length}');
      print('Data: $data');
    } else if (decoded is List) {
      print('\nResponse is List');
      print('List length: ${decoded.length}');
    }
  }
}
