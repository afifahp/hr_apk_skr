import 'package:flutter/material.dart';
import 'models/auth/user.dart';
import 'pages/auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRIS Mobile',
      theme: ThemeData(primarySwatch: Colors.blue),
      // 🔥 sekarang mulai dari Login
      home: const LoginPage(),
      routes: {
        "/attendance": (context) =>
            const Scaffold(body: Center(child: Text("Attendance Page"))),
        "/leave": (context) =>
            const Scaffold(body: Center(child: Text("Leave Page"))),
        "/salary": (context) =>
            const Scaffold(body: Center(child: Text("Salary Page"))),
        "/employee": (context) =>
            const Scaffold(body: Center(child: Text("Employee Page"))),
        "/leaveApproval": (context) =>
            const Scaffold(body: Center(child: Text("Leave Approval Page"))),
      },
    );
  }
}
