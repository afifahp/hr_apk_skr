import 'package:flutter/material.dart';
import '../models/auth/user.dart';
import '../pages/dashboard/dashboard_employee.dart';
import '../pages/dashboard/dashboard_hr.dart';
import '../pages/dashboard/dashboard_chief.dart';

class RoleManager {
  static Widget getDashboard(User user) {
    switch (user.role.toLowerCase()) {
      case 'employee':
        return DashboardEmployee(user: user);
      case 'hr':
        return DashboardHR(user: user);
      case 'chief':
        return DashboardChief(user: user);
      default:
        return Scaffold(
          body: Center(
            child: Text("Role ${user.role} tidak dikenali"),
          ),
        );
    }
  }
}
