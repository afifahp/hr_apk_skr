// helper / role-based config
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

  // ==== Role checkers ====
  static bool isEmployee(String role) => role.toLowerCase() == "employee";
  static bool isHR(String role) => role.toLowerCase() == "hr";
  static bool isChief(String role) => role.toLowerCase() == "chief";

  // ==== Chief SubRoles checkers ====
  static bool isCFO(String role, String? subRole) =>
      isChief(role) && (subRole?.toLowerCase() == "cfo");

  static bool isCTO(String role, String? subRole) =>
      isChief(role) && (subRole?.toLowerCase() == "cto");

  static bool isCOO(String role, String? subRole) =>
      isChief(role) && (subRole?.toLowerCase() == "coo");

  // Bisa tambah lagi subRole lain kalau perlu
}
