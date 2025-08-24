import 'package:flutter/material.dart';
import '../../models/auth/user.dart';
import '../dashboard/dashboard_chief.dart';
import '../dashboard/dashboard_hr.dart';
import '../dashboard/dashboard_employee.dart';
import '../leave/leave_page.dart';
import '../attendance/attendance_page.dart';
import '../salary/salary_page.dart';

class MainNavigation extends StatefulWidget {
  final User user;
  const MainNavigation({super.key, required this.user});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  
   Widget _getDashboard(User user) {
    if (user.isEmployee) return DashboardEmployee(user: user);
    if (user.isHR) return DashboardHR(user: user);
    if (user.isChief) {
      return DashboardChief(user: user);
    }
    return const Center(child: Text("Role tidak dikenali"));
  }

  @override
  Widget build(BuildContext context) {
    final isChief = widget.user.isChief;
    final isCFO = isChief && widget.user.subRole.toLowerCase() == "cfo";

    // 🔹 Tab sesuai role
    final tabs = [
      {
        "label": "Home",
        "icon": Icons.home,
        "page": _getDashboard(widget.user),
      },
      {
        "label": "Izin dan Cuti",
        "icon": Icons.calendar_month,
        "page": LeavePage(user: widget.user),
      },
      {
        "label": isChief ? "Kehadiran" : "Pengajuan Lain",
        "icon": isChief ? Icons.assignment : Icons.note_add,
        "page": AttendancePage(
          user: widget.user,
          attendances: [], // TODO: fetch dari AttendanceService
        ),
      },
      if (!isChief || isCFO) // Gaji hanya untuk Employee, HR, CFO
        {
          "label": "Gaji",
          "icon": Icons.payments,
          "page": SalaryPage(user: widget.user),
        },
    ];

    return Scaffold(
      body: tabs[_selectedIndex]["page"] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: tabs
            .map(
              (tab) => BottomNavigationBarItem(
                icon: Icon(tab["icon"] as IconData),
                label: tab["label"] as String,
              ),
            )
            .toList(),
      ),
    );
  }
}
