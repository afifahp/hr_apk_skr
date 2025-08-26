  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'dart:convert';

  import '../../models/auth/user.dart';
  import '../dashboard/dashboard_employee.dart';
  import '../dashboard/dashboard_hr.dart';
  import '../dashboard/dashboard_chief.dart';
  import '../../widgets/app_button.dart';

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

    Future<void> _login() async {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final response = await http.post(
          Uri.parse("http://localhost:8000/api/method/hrpay.api.login.auth"),
          body: {
            "email": _emailController.text,
            "password": _passwordController.text,
          },
        );

        if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Debug: dump seluruh response JSON
      print("Full response: $data");

      final user = User.fromJson(data);

      // Debug: dump isi user object
      print("User object: ${user.toString()}");
      print("Role mentah dari API: '${user.role}'");

      
  final role = data['message']?['user']?['role'] ?? "";
      print("Role setelah trim+lowercase: '$role'");

      if (role == "Employee") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardEmployee(user: user)),
        );
      } else if (role == "Accounts User") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardHR(user: user)),
        );
      } else if (role == "chief") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardChief(user: user)),
        );
      } else {
        setState(() => _errorMessage = "Role tidak dikenali: $role");
      }
    } else {
      setState(() => _errorMessage = "Login gagal: ${response.body}");
    }
      } catch (e) {
        setState(() => _errorMessage = "Error: $e");
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
                // 🔹 Logo
                Image.asset(
                  "assets/images/wip.gif", // pastikan ada di pubspec.yaml
                  height: 80,
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

                // 🔹 Email
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

                // 🔹 Password
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

                // 🔹 Tombol Login pakai AppButton
                AppButton(
                  type: ButtonType.login,   // pilih dari enum
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
 