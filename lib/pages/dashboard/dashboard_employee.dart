
// // file: dashboard_employee.dart
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../models/auth/user.dart';
// import '../../widgets/app_button.dart';
// import '../../widgets/popup.dart';
// import '../leave/leave_page_karyawan.dart';
// import '../attendance/attendance_page_karyawan.dart';

// class DashboardEmployee extends StatefulWidget {
//   final User user;

//   const DashboardEmployee({super.key, required this.user});

//   @override
//   State<DashboardEmployee> createState() => _DashboardEmployeeState();
// }

// class _DashboardEmployeeState extends State<DashboardEmployee> {
//   String employeeName = "";
//   String department = "";
//   String designation = "";
//   bool canCheckIn = false;
//   bool canCheckOut = false;
//   bool attendanceCompleted = false;
//   bool isLoading = false;
//   bool isLoadingEmployee = true;

//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadStatus();
//   }

//   Future<void> _loadStatus() async {
//     setState(() => isLoadingEmployee = true);
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final apiKey = prefs.getString('api_key') ?? "";
//       final apiSecret = prefs.getString('api_secret') ?? "";

//       final res = await http.get(
//         Uri.parse("http://localhost:8000/api/method/hrpay.api.attendance.check_status"),
//         headers: {
//           "Authorization": "token $apiKey:$apiSecret",
//           "Content-Type": "application/json",
//         },
//       );

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         final msg = data["message"];
//         if (msg != null) {
//           final emp = msg["employee"];
//           final todayStatus = msg["today_status"];

//           setState(() {
//             employeeName = emp["employee_name"] ?? "";
//             department = emp["department"] ?? "-";
//             designation = emp["designation"] ?? "-";
//             canCheckIn = todayStatus["can_check_in"] ?? false;
//             canCheckOut = todayStatus["can_check_out"] ?? false;
//             attendanceCompleted = todayStatus["attendance_completed"] ?? false;
//             isLoadingEmployee = false;
//           });
//         }
//       } else {
//         debugPrint("❌ Gagal load status: ${res.body}");
//         setState(() => isLoadingEmployee = false);
//       }
//     } catch (e) {
//       debugPrint("❌ Error load status: $e");
//       setState(() => isLoadingEmployee = false);
//     }
//   }

//   Future<void> _toggleAttendance() async {
//     setState(() => isLoading = true);
//     final prefs = await SharedPreferences.getInstance();
//     final apiKey = prefs.getString('api_key') ?? "";
//     final apiSecret = prefs.getString('api_secret') ?? "";

//     String endpoint = "";
//     if (canCheckIn) {
//       endpoint = "http://localhost:8000/api/method/hrpay.api.attendance.employee_check_in";
//     } else if (canCheckOut) {
//       endpoint = "http://localhost:8000/api/method/hrpay.api.attendance.employee_check_out";
//     } else {
//       PopupMessage.show(
//         context: context,
//         title: "Absensi",
//         message: "Absensi hari ini sudah selesai",
//         success: false,
//       );
//       setState(() => isLoading = false);
//       return;
//     }

//     try {
//       final res = await http.post(
//         Uri.parse(endpoint),
//         headers: {
//           "Authorization": "token $apiKey:$apiSecret",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "employee": employeeName,
//           "work_mode": "WFO", // bisa diganti sesuai kebutuhan
//         }),
//       );

//       final data = jsonDecode(res.body);

//       if (res.statusCode == 200) {
//         final msg = data["message"];
//         PopupMessage.show(
//           context: context,
//           title: "Absensi",
//           message: msg["message"] ?? "Berhasil update absensi",
//           success: msg["success"] ?? true,
//         );
//         await _loadStatus(); // refresh status setelah check-in/out
//       } else {
//         debugPrint("❌ Gagal check_in/out: ${res.body}");
//         PopupMessage.show(
//           context: context,
//           title: "Absensi",
//           message: "Gagal update absensi",
//           success: false,
//         );
//       }
//     } catch (e) {
//       debugPrint("❌ Error toggleAttendance: $e");
//       PopupMessage.show(
//         context: context,
//         title: "Absensi",
//         message: "Terjadi kesalahan saat absensi",
//         success: false,
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Widget _buildDashboard() {
//     if (isLoadingEmployee) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (employeeName.isEmpty) {
//       return const Center(
//         child: Text("❌ Data employee tidak ditemukan"),
//       );
//     }

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Halo, $employeeName!",
//               style: const TextStyle(
//                   fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 16),
//           Text("Departemen: $department"),
//           Text("Jabatan: $designation"),
//           const SizedBox(height: 16),
//           AppButton(
//             type: canCheckIn
//                 ? ButtonType.checkIn
//                 : (canCheckOut ? ButtonType.checkOut : ButtonType.selesai),
//             text: canCheckIn ? "Check-In" : (canCheckOut ? "Check-Out" : "Selesai"),
//             isLoading: isLoading,
//             isDisabled: !(canCheckIn || canCheckOut),
//             onPressed: _toggleAttendance,
//           ),
//         ],
//       ),
//     );
//   }

//   void _onItemTapped(int index) {
//     if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => LeavePageKaryawan(user: widget.user),
//         ),
//       );
//     } else if (index == 2) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => AttendancePageKaryawan(user: widget.user),
//         ),
//       );
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dashboard Employee"),
//         centerTitle: true,
//       ),
//       body: _selectedIndex == 0 ? _buildDashboard() : const SizedBox.shrink(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
//           BottomNavigationBarItem(icon: Icon(Icons.time_to_leave), label: "Izin dan Cuti"),
//           BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Kehadiran"),
//         ],
//       ),
//     );
//   }
// }



// file: dashboard_employee.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/auth/user.dart';
import '../../widgets/app_button.dart';
import '../../widgets/popup.dart';
import '../leave/leave_page_karyawan.dart';
import '../attendance/attendance_page_karyawan.dart';
import '../attendance/attendance_form.dart';
import '../auth/login_page.dart';


class DashboardEmployee extends StatefulWidget {
  final User user;

  const DashboardEmployee({super.key, required this.user});

  @override
  State<DashboardEmployee> createState() => _DashboardEmployeeState();
}

class _DashboardEmployeeState extends State<DashboardEmployee> {


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

  String employeeName = "";
  String department = "";
  String designation = "";
  bool canCheckIn = false;
  bool canCheckOut = false;
  bool attendanceCompleted = false;
  bool isLoading = false;
  bool isLoadingEmployee = true;
  bool isWFHMode = false; // defaultnya WFO

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    setState(() => isLoadingEmployee = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('api_key') ?? "";
      final apiSecret = prefs.getString('api_secret') ?? "";

      final res = await http.get(
        Uri.parse("http://localhost:8000/api/method/hrpay.api.attendance.check_status"),
        headers: {
          "Authorization": "token $apiKey:$apiSecret",
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final msg = data["message"];
        if (msg != null) {
          final emp = msg["employee"];
          final todayStatus = msg["today_status"];

          setState(() {
            employeeName = emp["employee_name"] ?? "";
            department = emp["department"] ?? "-";
            designation = emp["designation"] ?? "-";
            canCheckIn = todayStatus["can_check_in"] ?? false;
            canCheckOut = todayStatus["can_check_out"] ?? false;
            attendanceCompleted = todayStatus["attendance_completed"] ?? false;
            isLoadingEmployee = false;
          });
        }
      } else {
        debugPrint("❌ Gagal load status: ${res.body}");
        setState(() => isLoadingEmployee = false);
      }
    } catch (e) {
      debugPrint("❌ Error load status: $e");
      setState(() => isLoadingEmployee = false);
    }
  }

  Future<void> _toggleAttendance() async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('api_key') ?? "";
    final apiSecret = prefs.getString('api_secret') ?? "";

    String endpoint = "";
    if (canCheckIn) {
      endpoint = "http://localhost:8000/api/method/hrpay.api.attendance.employee_check_in";
    } else if (canCheckOut) {
      endpoint = "http://localhost:8000/api/method/hrpay.api.attendance.employee_check_out";
    } else {
      PopupMessage.show(
        context: context,
        title: "Absensi",
        message: "Absensi hari ini sudah selesai",
        success: false,
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      final res = await http.post(
        Uri.parse(endpoint),
        headers: {
          "Authorization": "token $apiKey:$apiSecret",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "employee": employeeName,
          "work_mode": "WFO", // Regular check-in/out
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final msg = data["message"];
        PopupMessage.show(
          context: context,
          title: "Absensi",
          message: msg["message"] ?? "Berhasil update absensi",
          success: msg["success"] ?? true,
        );
        await _loadStatus(); // refresh status setelah check-in/out
      } else {
        debugPrint("❌ Gagal check_in/out: ${res.body}");
        PopupMessage.show(
          context: context,
          title: "Absensi",
          message: "Gagal update absensi",
          success: false,
        );
      }
    } catch (e) {
      debugPrint("❌ Error toggleAttendance: $e");
      PopupMessage.show(
        context: context,
        title: "Absensi",
        message: "Terjadi kesalahan saat absensi",
        success: false,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Function untuk WFH Check-In / Check-Out
  Future<void> _toggleWFHAttendance() async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('api_key') ?? "";
    final apiSecret = prefs.getString('api_secret') ?? "";

    String endpoint = "";
    if (canCheckIn) {
      endpoint = "http://localhost:8000/api/method/hrpay.api.attendance.employee_check_in";
    } else if (canCheckOut) {
      endpoint = "http://localhost:8000/api/method/hrpay.api.attendance.employee_check_out";
    } else {
      PopupMessage.show(
        context: context,
        title: "Absensi WFH",
        message: "Absensi WFH hari ini sudah selesai",
        success: false,
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      final res = await http.post(
        Uri.parse(endpoint),
        headers: {
          "Authorization": "token $apiKey:$apiSecret",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "employee": employeeName,
          "work_mode": "WFH", // Khusus WFH
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final msg = data["message"];
        PopupMessage.show(
          context: context,
          title: "Absensi WFH",
          message: msg["message"] ?? "Berhasil update absensi WFH",
          success: msg["success"] ?? true,
        );
        await _loadStatus(); // refresh status setelah check-in/out
      } else {
        debugPrint("❌ Gagal WFH check_in/out: ${res.body}");
        PopupMessage.show(
          context: context,
          title: "Absensi WFH",
          message: "Gagal update absensi WFH",
          success: false,
        );
      }
    } catch (e) {
      debugPrint("❌ Error toggleWFHAttendance: $e");
      PopupMessage.show(
        context: context,
        title: "Absensi WFH",
        message: "Terjadi kesalahan saat absensi WFH",
        success: false,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

Widget _buildDashboard() {
  if (isLoadingEmployee) {
    return const Center(child: CircularProgressIndicator());
  }

  if (employeeName.isEmpty) {
    return const Center(
      child: Text("❌ Data employee tidak ditemukan"),
    );
  }


  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Halo, $employeeName!",
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text("Departemen: $department"),
        Text("Jabatan: $designation"),
        const SizedBox(height: 16),

        Row(
  children: [
    // Tombol WFO
    Expanded(
      child: AppButton(
        type: canCheckIn
            ? ButtonType.checkIn
            : (canCheckOut ? ButtonType.checkOut : ButtonType.selesai),
        text: canCheckIn
            ? "Check-In"
            : (canCheckOut ? "Check-Out" : "Selesai"),
        isLoading: isLoading,
        // kalau sudah mode WFH → disable tombol WFO
        isDisabled: !(canCheckIn || canCheckOut) || isWFHMode,
        onPressed: () {
          setState(() => isWFHMode = false);
          _toggleAttendance();
        },
      ),
    ),
    const SizedBox(width: 12),

    // Tombol WFH
    Expanded(
      child: AppButton(
        type: canCheckIn
            ? ButtonType.checkIn
            : (canCheckOut ? ButtonType.checkOut : ButtonType.selesai),
        text: canCheckIn
            ? "WFH Check-In"
            : (canCheckOut ? "WFH Check-Out" : "WFH Selesai"),
        isLoading: false,
        // kalau sudah mode WFO → disable tombol WFH
        isDisabled: !(canCheckIn || canCheckOut) || !isWFHMode && !canCheckIn,
        onPressed: () {
          setState(() => isWFHMode = true);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttendanceForm(
                user: widget.user,
                employeeName: employeeName,
                department: department,
              ),
            ),
          );
        },
      ),
    ),
  ],
),

      ],
    ),
  );
}
  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LeavePageKaryawan(user: widget.user),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendancePageKaryawan(user: widget.user),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Employee"),
        centerTitle: true,
        automaticallyImplyLeading: false,
              actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ), // ⬅️ hapus tombol panah kiri
        ],
      ),
      body: _selectedIndex == 0 ? _buildDashboard() : const SizedBox.shrink(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.time_to_leave), label: "Izin dan Cuti"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Kehadiran"),
        ],
      ),
    );
  }
}
