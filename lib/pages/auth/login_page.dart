import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/auth/user.dart';
import 'dart:convert';

// Import dashboard pages
import '../dashboard/dashboard_employee.dart';
import '../dashboard/dashboard_hr.dart';
import '../dashboard/dashboard_chief.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse("https://your-frappe-api.com/api/method/login"),
        body: {
          "usr": _emailController.text,
          "pwd": _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Parse ke User model
        final user = User.fromJson(data);

       if (user.role.toLowerCase() == "employee") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardEmployee(user: user)),
          );
        } else if (user.role.toLowerCase() == "hr") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardHR(user: user)),
          );
        } else if (user.role.toLowerCase() == "chief") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardChief(user: user)),
          );
        } else {
          setState(() {
            _errorMessage = "Role tidak dikenali";
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login to Manusa",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  hintText: "yourmail@mail.com",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
