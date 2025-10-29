import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const PasswordInputField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscure,
      // 👇 Warna teks & bintang jadi hitam
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: 'Poppins',
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.grey, // warna placeholder abu-abu
          fontFamily: 'Poppins',
        ),
        filled: true,
        fillColor: AppColors.white,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.inputBorder,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
