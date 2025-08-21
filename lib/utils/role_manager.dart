//helper / role-based config
import 'package:flutter/material.dart';
import '../pages/dashboard/dashboard_employee.dart';
import '../pages/dashboard/dashboard_hr.dart';
import '../pages/dashboard/dashboard_chief.dart';

class RoleManager {
  static Widget getDashboard(String role, {String? subRole}) {
    switch (role.toLowerCase()) {
      case 'employee':
        return DashboardEmployee();
      case 'hr':
        return DashboardHR();
      case 'chief':
        return DashboardChief(subRole: subRole ?? "");
      default:
        return Scaffold(
          body: Center(
            child: Text("Role $role tidak dikenali"),
          ),
        );
    }
  }
}
