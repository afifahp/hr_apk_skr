import 'package:flutter/material.dart';
import 'utils/role_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // contoh hardcode role (nanti ambil dari backend pas login)
  final String role = "employee";
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRIS Mobile',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RoleManager.getDashboard(role, subRole: subRole),
      routes: {
        "/attendance": (context) => Scaffold(body: Center(child: Text("Attendance Page"))),
        "/leave": (context) => Scaffold(body: Center(child: Text("Leave Page"))),
        "/salary": (context) => Scaffold(body: Center(child: Text("Salary Page"))),
        "/employee": (context) => Scaffold(body: Center(child: Text("Employee Page"))),
        "/leaveApproval": (context) => Scaffold(body: Center(child: Text("Leave Approval Page"))),
      },
    );
  }
}
