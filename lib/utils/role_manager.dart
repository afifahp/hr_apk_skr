import 'package:flutter/material.dart';
import '../models/auth/user.dart';
import '../pages/dashboard/dashboard_employee.dart';
import '../pages/dashboard/dashboard_hr.dart';
import '../pages/dashboard/dashboard_chief.dart';

class RoleManager {
  static Widget getDashboard(User user) {
    print("DEBUG RoleManager → rawRole=${user.role}, subRole=${user.subRole}");

    if (user.isEmployee) {
      return DashboardEmployee(user: user);
    } else if (user.isHR) {
      return DashboardHR(user: user);
    } else if (user.isChief) {
      return DashboardChief(user: user);
    }

    // fallback kalau role nggak dikenali
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.red.shade400,
      ),
      body: Center(
        child: Text("Role '${user.role}' tidak dikenali"),
      ),
    );
  }
}
