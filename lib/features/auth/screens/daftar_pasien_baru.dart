import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/models/user_model.dart';
import 'package:flutter_klinik_gigi/core/services/auth_service.dart';

class LoginPage extends StatefulWidget { 
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthServiceLocal authService = AuthServiceLocal();

  bool isLoading = false;
  String? errorMsg;

  void handleLogin() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });

    final user = await authService.login(
      emailController.text,
      passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (user != null) {
      // sukses login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selamat datang, ${user.namaPengguna}!')),
      );
      // TODO: navigasi ke halaman utama
    } else {
      setState(() {
        errorMsg = 'Email atau password salah';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Color(0xFFE1D07E)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Color(0xFFE1D07E)),
              ),
            ),
            const SizedBox(height: 20),
            if (errorMsg != null)
              Text(errorMsg!,
                  style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE1D07E),
                foregroundColor: Colors.black,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}