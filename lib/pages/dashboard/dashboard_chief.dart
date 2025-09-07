// import 'package:flutter/material.dart';
// import '../../models/auth/user.dart';
// import '../leave/leave_page.dart';
// import '../attendance/attendance_page.dart';
// import '../salary/salary_page.dart';

// class DashboardChief extends StatefulWidget {
//   final User user;

//   const DashboardChief({super.key, required this.user});

//   @override
//   State<DashboardChief> createState() => _DashboardChiefState();
// }

// class _DashboardChiefState extends State<DashboardChief> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final user = widget.user;

  
//     final List<Map<String, dynamic>> tabs = [
//       {
//         "label": "Home",
//         "icon": Icons.home,
//         "page": Center(
//           child: Text("Dashboard Chief ${user.subRole} - ${user.employeeName}"),
//         ),
//       },
//       {
//         "label": "Izin & Cuti",
//         "icon": Icons.time_to_leave,
//         "page": LeavePage(user: user),
//       },
//       {
//         "label": "Kehadiran",
//         "icon": Icons.calendar_month,
//         "page": AttendancePage(user: user),
//       },
//     ];

//     return Scaffold(
//       body: tabs[_currentIndex]["page"],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//         items: tabs
//             .map((tab) => BottomNavigationBarItem(
//                   icon: Icon(tab["icon"]),
//                   label: tab["label"],
//                 ))
//             .toList(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/auth/user.dart';
import '../leave/leave_page.dart';
import '../attendance/attendance_page.dart';
import '../auth/login_page.dart'; // Pastikan ada halaman login

class DashboardChief extends StatefulWidget {
  final User user;

  const DashboardChief({super.key, required this.user});

  @override
  State<DashboardChief> createState() => _DashboardChiefState();
}

class _DashboardChiefState extends State<DashboardChief> {
  int _currentIndex = 0;

  // 🔹 Fungsi logout
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // hapus semua data user/token

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()), // arahkan ke login
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    final List<Map<String, dynamic>> tabs = [
      {
        "label": "Home",
        "icon": Icons.home,
        "page": Center(
          child: Text(
            "Dashboard Chief ${user.subRole} - ${user.employeeName}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      },
      {
        "label": "Izin & Cuti",
        "icon": Icons.time_to_leave,
        "page": LeavePage(user: user),
      },
      {
        "label": "Kehadiran",
        "icon": Icons.calendar_month,
        "page": AttendancePage(user: user),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        automaticallyImplyLeading: false, // ⬅️ hapus tombol panah kiri
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
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
