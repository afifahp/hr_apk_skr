import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/attendance/attendance.dart';
import 'package:flutter_application_1/pages/employee/employee_page.dart';
import 'package:flutter_application_1/pages/leave/leave_page.dart';
import 'package:flutter_application_1/services/attendance_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/auth/user.dart';
import 'pages/auth/login_page.dart';
import 'pages/salary/salary_page.dart';
import 'pages/attendance/attendance_page.dart';
import 'pages/employee/employee_detail.dart';

Future<void> main() async {
  // 🔹 Pastikan Flutter siap sebelum async
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Ambil instance SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  Future<User?> _getUserFromPrefs() async {
    final userJson = prefs.getString("user_data");
    if (userJson != null) {
      final data = json.decode(userJson);
      return User.fromJson(data); // pastikan User punya fromJson
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRIS Mobile',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(), // default ke login
      routes: {
        "/attendance": (context) {
  return FutureBuilder<User?>(
    future: _getUserFromPrefs(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (snapshot.hasError) {
        return Scaffold(
          body: Center(child: Text("Error: ${snapshot.error}")),
        );
      } else if (snapshot.hasData && snapshot.data != null) {
        final user = snapshot.data!;
        return FutureBuilder<List<Attendance>>(
          future: AttendanceService.getAllAttendance(),  // 👈 ambil data dari API/local
          builder: (context, attendSnapshot) {
            if (attendSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (attendSnapshot.hasError) {
              return Scaffold(
                body: Center(child: Text("Error: ${attendSnapshot.error}")),
              );
            } else if (attendSnapshot.hasData) {
              return AttendancePage(
                user: user,
              );
            } else {
              return AttendancePage(
                user: user,
            );
            }
          },
        );
      } else {
        return const Scaffold(
          body: Center(child: Text("User tidak ditemukan")),
        );
      }
    },
  );
},

        "/leave": (context) {
  return FutureBuilder<User?>(
    future: _getUserFromPrefs(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (snapshot.hasError) {
        return Scaffold(
          body: Center(child: Text("Error: ${snapshot.error}")),
        );
      } else if (snapshot.hasData && snapshot.data != null) {
        final user = snapshot.data!;
        return FutureBuilder<List<Attendance>>(
          future: AttendanceService.getAllAttendance(), // ambil data dari API
          builder: (context, attendSnapshot) {
            if (attendSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (attendSnapshot.hasError) {
              return Scaffold(
                body: Center(child: Text("Error: ${attendSnapshot.error}")),
              );
            } else if (attendSnapshot.hasData) {
              return LeavePage(
                user: user,
                // attendances: attendSnapshot.data!, // ✅ kirim data attendance ke LeavePage
              );
            } else {
              return LeavePage(
                user: user,
                // attendances: const [], // kalau kosong
              );
            }
          },
        );
      } else {
        return const Scaffold(
          body: Center(child: Text("User tidak ditemukan")),
        );
      }
    },
  );
},

        "/salary": (context) {
          // 🔹 Ambil user dari SharedPreferences
          return FutureBuilder<User?>(
            future: _getUserFromPrefs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text("Error: ${snapshot.error}")),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                return SalaryPage(user: snapshot.data!);
              } else {
                return const Scaffold(
                  body: Center(child: Text("User tidak ditemukan")),
                );
              }
            },
          );
        },
        "/employee": (context) {
  return FutureBuilder<User?>(
    future: _getUserFromPrefs(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (snapshot.hasError) {
        return Scaffold(
          body: Center(child: Text("Error: ${snapshot.error}")),
        );
      }

   if (snapshot.hasData && snapshot.data != null) {
  final user = snapshot.data!;
  return EmployeeListPage(
    
  );
}

      return Scaffold(
  appBar: AppBar(
    title: const Text("Karyawan"),
  ),
  body: const Center(
    child: Text("User tidak ditemukan"),
  ),
);

    },
  );
},
        "/leaveApproval": (context) =>
            const Scaffold(body: Center(child: Text("Leave Approval Page"))),
      },
    );
  }
}
