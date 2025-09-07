import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/attendance/attendance.dart';
import 'package:flutter_application_1/pages/employee/employee_page.dart';
import 'package:flutter_application_1/pages/leave/leave_page.dart';
import 'package:flutter_application_1/services/attendance_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/auth/user.dart';
import 'pages/auth/login_page.dart';
import 'pages/attendance/attendance_page.dart';
import 'pages/attendance/attendance_detail.dart';
// import 'pages/employee/employee_detail.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      return User.fromJson(data);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRIS Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F4FF),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey[200]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue.shade300, width: 1),
          ),
          labelStyle: TextStyle(color: Colors.black87),
        ),
      ),  
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
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
                  future: AttendanceService.fetchAllAttendance(),
                  builder: (context, attendSnapshot) {
                    if (attendSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    } else if (attendSnapshot.hasError) {
                      return Scaffold(
                        body: Center(
                            child: Text("Error: ${attendSnapshot.error}")),
                      );
                    } else {
                      return AttendancePage(user: user);
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
                  future: AttendanceService.fetchAllAttendance(),
                  builder: (context, attendSnapshot) {
                    if (attendSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    } else if (attendSnapshot.hasError) {
                      return Scaffold(
                        body: Center(
                            child: Text("Error: ${attendSnapshot.error}")),
                      );
                    } else {
                      return LeavePage(user: user);
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

        "/attendance/attendance_detail": (context) {
          final attendance = ModalRoute.of(context)!.settings.arguments as Attendance;
          return AttendanceDetailPage(attendance: attendance);
    },


        // "/salary": (context) {
        //   return const Scaffold(
        //     appBar: AppBar(
        //       title: Text("Salary"),
        //     ),
        //     body: Center(
        //       child: Text("Salary Page belum tersedia"),
        //     ),
        //   );
        // },

        "/employee": (context) {
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
                return const EmployeeListPage();
              } else {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("Karyawan"),
                  ),
                  body: const Center(
                    child: Text("User tidak ditemukan"),
                  ),
                );
              }
            },
          );
        },

        "/leaveApproval": (context) =>
            const Scaffold(body: Center(child: Text("Leave Approval Page"))),
      },
    );
  }
}
