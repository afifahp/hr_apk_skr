// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../../models/auth/user.dart';
// import '../dashboard/dashboard_employee.dart';
// import '../dashboard/dashboard_hr.dart';
// import '../dashboard/dashboard_chief.dart';
// import '../../widgets/app_button.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   String? _errorMessage;

//   Future<void> _login() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse("http://172.31.62.57:8000"),
//         body: {
//           "usr": _emailController.text,
//           "pwd": _passwordController.text,
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final user = User.fromJson(data);

//         if (user.role.toLowerCase() == "employee") {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => DashboardEmployee(user: user)),
//           );
//         } else if (user.role.toLowerCase() == "hr") {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => DashboardHR(user: user)),
//           );
//         } else if (user.role.toLowerCase() == "chief") {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => DashboardChief(user: user)),
//           );
//         } else {
//           setState(() => _errorMessage = "Role tidak dikenali");
//         }
//       } else {
//         setState(() => _errorMessage = "Login gagal: ${response.body}");
//       }
//     } catch (e) {
//       setState(() => _errorMessage = "Error: $e");
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // 🔹 Logo
//               Image.asset(
//                 "assets/images/wip.gif", // pastikan ada di pubspec.yaml
//                 height: 80,
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 "GCG MANUSA",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 40),

//               const Text(
//                 "Login to Manusa",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 32),

//               // 🔹 Email
//               TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: "E-mail",
//                   hintText: "yourmail@mail.com",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12)),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // 🔹 Password
//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscurePassword,
//                 decoration: InputDecoration(
//                   labelText: "Password",
//                   border: const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12)),
//                   ),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                     ),
//                     onPressed: () {
//                       setState(() => _obscurePassword = !_obscurePassword);
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               if (_errorMessage != null)
//                 Text(
//                   _errorMessage!,
//                   style: const TextStyle(color: Colors.red),
//                   textAlign: TextAlign.center,
//                 ),
//               const SizedBox(height: 16),

//               // 🔹 Tombol Login pakai AppButton
//               AppButton(
//                 type: ButtonType.login,   // pilih dari enum
//                 isLoading: _isLoading,
//                 isDisabled: _isLoading,
//                 onPressed: _login,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import '../../models/auth/user.dart';
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
  String? _errorMessage;

  // 🔹 Dummy user list
final List<Map<String, String>> dummyUsers = [
  {
    "id": "1",
    "name": "Budi Employee",
    "email": "employee@mail.com",
    "password": "123456",      // tambahan untuk login check
    "role": "employee",
    "subRole": "staff",
    "token": "token_employee_123"
  },
  {
    "id": "2",
    "name": "Sari HR",
    "email": "hr@mail.com",
    "password": "123456",
    "role": "hr",
    "subRole": "recruiter",
    "token": "token_hr_123"
  },
  {
    "id": "3",
    "name": "Andi Chief",
    "email": "chief@mail.com",
    "password": "123456",
    "role": "chief",
    "subRole": "manager",
    "token": "token_chief_123"
  },
];

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Cari user dari dummy list
    final User = dummyUsers.firstWhere(
      (u) => u["email"] == email && u["password"] == password,
      orElse: () => {},
    );

    if (User.isEmpty) {
      setState(() => _errorMessage = "Email atau password salah!");
      return;
    }

    final role = User["role"];

    // Buat object User dari dummy
    // final loggedInUser = user( email: user["email"]!, role: user["role"]! );

    // Tentukan halaman tujuan
    Widget page;
    if (role == "employee") {
      page = DashboardEmployee(user: User);
    } else if (role == "hr") {
      page = DashboardHR(user: loggedInUser);
    } else if (role == "chief") {
      page = DashboardChief(user: loggedInUser);
    } else {
      setState(() => _errorMessage = "Role tidak dikenali");
      return;
    }

    // Redirect ke halaman dashboard sesuai role
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
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
              const Text("Login Dummy", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              ElevatedButton(onPressed: _login, child: const Text("Login")),

              if (_errorMessage != null) ...[
                const SizedBox(height: 20),
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
