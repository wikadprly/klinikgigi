import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_klinik_gigi/core/utils/validator.dart'; // sesuaikan dengan nama project kamu

void main() {
  group('Validator Tests', () {
    test('Validasi Email', () {
      expect(Validator.validateEmail(''), 'Email tidak boleh kosong');
      expect(Validator.validateEmail('abc'), 'Format email tidak valid');
      expect(Validator.validateEmail('test@example.com'), null);
    });

    test('Validasi Password', () {
      expect(Validator.validatePassword(''), 'Password tidak boleh kosong');
      expect(Validator.validatePassword('123'), 'Password minimal 6 karakter');
      expect(Validator.validatePassword('123456'), null);
    });

    test('Validasi Nomor HP', () {
      expect(Validator.validatePhone(''), 'Nomor HP tidak boleh kosong');
      expect(
        Validator.validatePhone('abc123'),
        'Nomor HP harus berupa angka 10–13 digit',
      );
      expect(Validator.validatePhone('08123456789'), null);
    });

    test('Validasi NIK', () {
      expect(Validator.validateNIK(''), 'NIK tidak boleh kosong');
      expect(Validator.validateNIK('12345'), 'NIK harus 16 digit angka');
      expect(Validator.validateNIK('1234567890123456'), null);
    });

    test('Validasi Nama', () {
      expect(Validator.validateName(''), 'Nama tidak boleh kosong');
      expect(
        Validator.validateName('123'),
        'Nama hanya boleh berisi huruf dan spasi',
      );
      expect(Validator.validateName('Rafly Firmansyah'), null);
    });

    test('Validasi Tanggal Lahir', () {
      expect(
        Validator.validateBirthDate(''),
        'Tanggal lahir tidak boleh kosong',
      );
      expect(Validator.validateBirthDate('12/05/2000'), null);
    });
  });
}
