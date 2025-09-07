import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/auth/user.dart';
import '../dashboard/dashboard_employee.dart';
import '../dashboard/dashboard_hr.dart';
import '../dashboard/dashboard_chief.dart';
import '../../widgets/app_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // Fungsi untuk menampilkan popup/alert
  void _showAlertDialog({required String title, required String content, bool isError = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          icon: Icon(
            isError ? Icons.error_outline : Icons.check_circle,
            color: isError ? Colors.red : Colors.green,
            size: 40,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan loading dialog
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Sedang memproses..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Tampilkan loading dialog
    _showLoadingDialog();

    try {
      final response = await http.post(
        Uri.parse("http://localhost:8000/api/method/hrpay.api.login.auth"),
        body: {
          "email": _emailController.text,
          "password": _passwordController.text,
        },
      );

      // Tutup loading dialog
      Navigator.of(context).pop();

      print("Raw response.body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Decoded JSON: $data");

        final userJson = data['message']?['user'];
        
        if (userJson == null) {
          _showAlertDialog(
            title: "Login Gagal",
            content: "Data user tidak ditemukan dalam response",
            isError: true,
          );
          return;
        }
        
        final user = User.fromJson(userJson);

        print("DEBUG User => role: ${user.role}, subRole: ${user.subRole}, isChief: ${user.isChief}");
        print("DEBUG All roles: ${user.roles}");

        // Simpan ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user_data', json.encode(userJson));
        prefs.setString('user_role', user.role);
        prefs.setString('sid', data['message']?['sid'] ?? "");
        prefs.setString('api_key', data['message']?['api_key'] ?? "");
        prefs.setString('api_secret', data['message']?['api_secret'] ?? "");

        // Tampilkan alert sukses login
        _showAlertDialog(
          title: "Login Berhasil",
          content: "Login berhasil! Mengarahkan ke dashboard...",
          isError: false,
        );

        // 🔹 PERUBAHAN PENTING: 
        // Prioritaskan Chief Officer terlebih dahulu, karena seorang Chief Officer
        // bisa juga memiliki role Employee atau HR
        if (user.isChief) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardChief(user: user)),
          );
        } else if (user.isHR) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardHR(user: user)),
          );
        } else if (user.isEmployee) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardEmployee(user: user)),
          );
        } else {
          _showAlertDialog(
            title: "Role Tidak Dikenali",
            content: "Role tidak dikenali. Roles: ${user.roles.join(', ')}",
            isError: true,
          );
        }
      } else {
        _showAlertDialog(
          title: "Login Gagal",
          content: "Login gagal: ${response.statusCode}",
          isError: true,
        );
      }
    } catch (e) {
      // Tutup loading dialog jika masih terbuka
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      _showAlertDialog(
        title: "Error",
        content: "Terjadi kesalahan: $e",
        isError: true,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/manusa_nobg.png",
                height: 100,
                width: 120,
              ),
              const SizedBox(height: 12),
              const Text(
                "GCG MANUSA",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              const Text(
                "Login to Manusa",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  hintText: "yourmail@mail.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 16),

              AppButton(
                type: ButtonType.login,
                isLoading: _isLoading,
                isDisabled: _isLoading,
                onPressed: _login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}