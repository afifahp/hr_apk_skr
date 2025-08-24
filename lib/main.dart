import 'package:flutter/material.dart';
import 'models/auth/user.dart';       // <-- IMPORT User
import 'utils/role_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // contoh dummy user (nanti diganti hasil login)
  final User user = User(
    id: "123",
    name: "John Doe",
    email: "john@example.com",
    role: "employee",   // employee, hr, chief
    subRole: "",        // kalau chief -> isi "cfo", "cto", dst
    token: "dummy-token",
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRIS Mobile',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RoleManager.getDashboard(user), // <-- cukup lempar User
      routes: {
        "/attendance": (context) => const Scaffold(body: Center(child: Text("Attendance Page"))),
        "/leave": (context) => const Scaffold(body: Center(child: Text("Leave Page"))),
        "/salary": (context) => const Scaffold(body: Center(child: Text("Salary Page"))),
        "/employee": (context) => const Scaffold(body: Center(child: Text("Employee Page"))),
        "/leaveApproval": (context) => const Scaffold(body: Center(child: Text("Leave Approval Page"))),
      },
    );
  }
}
