import 'package:flutter/material.dart';
import '../../models/auth/user.dart';
import '../leave/leave_page.dart';
import '../attendance/attendance_page.dart';
import '../salary/salary_page.dart';

class DashboardChief extends StatefulWidget {
  final User user;

  const DashboardChief({super.key, required this.user});

  @override
  State<DashboardChief> createState() => _DashboardChiefState();
}

class _DashboardChiefState extends State<DashboardChief> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

  
    final List<Map<String, dynamic>> tabs = [
      {
        "label": "Home",
        "icon": Icons.home,
        "page": Center(
          child: Text("Dashboard Chief ${user.subRole} - ${user.employeeName}"),
        ),
      },
      {
        "label": "Izin & Cuti",
        "icon": Icons.calendar_month,
        "page": LeavePage(user: user),
      },
      {
        "label": "Kehadiran",
        "icon": Icons.assignment,
        "page": AttendancePage(user: user),
      },
    ];

    return Scaffold(
      body: tabs[_currentIndex]["page"],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: tabs
            .map((tab) => BottomNavigationBarItem(
                  icon: Icon(tab["icon"]),
                  label: tab["label"],
                ))
            .toList(),
      ),
    );
  }
}
