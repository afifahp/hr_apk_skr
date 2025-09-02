import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/auth/user.dart';
import '../dashboard/dashboard_employee.dart';
import '../dashboard/dashboard_hr.dart';
import '../dashboard/dashboard_chief.dart';
import '../../widgets/app_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/popup.dart'; // 🔹 import popup

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

  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("http://localhost:8000/api/method/hrpay.api.login.auth"),
        body: {
          "usr": _emailController.text,
          "pwd": _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final token = data['message']?['token'] ?? "";

        // ✅ bikin user dari JSON
        final user = User.fromJson(data['message']?['user'] ?? {});
        final userWithToken = User(
          id: user.id,
          email: user.email,
          role: user.role,
          subRole: user.subRole,
          token: token,
          employeeName: user.employeeName,
          department: user.department,
          jobPosition: user.jobPosition,
          leaveApprover: user.leaveApprover,
        );

        // ✅ simpan ke local storage
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user_data', json.encode(data['message']?['user']));
        prefs.setString('user_role', user.role);
        prefs.setString('token', token);

        // ✅ navigasi berdasarkan role (pakai getter dari user.dart)
        if (userWithToken.isEmployee) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DashboardEmployee(user: userWithToken),
            ),
          );
        } else if (userWithToken.isHR) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DashboardHR(user: userWithToken),
            ),
          );
        } else if (userWithToken.isChief) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DashboardChief(user: userWithToken),
            ),
          );
        } else {
          PopupMessage.show(
            context: context,
            title: "Login Error",
            message: "Role tidak dikenali: ${userWithToken.role} "
                "(subRole: ${userWithToken.subRole})",
            success: false,
          );
        }
      } else {
        final data = json.decode(response.body);
        PopupMessage.show(
          context: context,
          title: "Login Gagal",
          message: data['message']?.toString() ?? "Terjadi kesalahan. Coba lagi.",
          success: false,
        );
      }
    } catch (e) {
      PopupMessage.show(
        context: context,
        title: "Error Koneksi",
        message: e.toString(),
        success: false,
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
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: AppButton(
                  type: ButtonType.login,
                  isLoading: _isLoading,
                  isDisabled: _isLoading,
                  onPressed: _login,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
