import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/auth/user.dart';
import '../../models/employee/employee.dart';
import '../../widgets/app_button.dart';
import '../../widgets/popup.dart';
import '../auth/login_page.dart';
import '../leave/leave_page_karyawan.dart';
import '../attendance/attendance_form.dart';
import '../attendance/attendance_page.dart';

class DashboardEmployee extends StatefulWidget {
  final User user;

  const DashboardEmployee({
    super.key,
    required this.user,
  });

  @override
  State<DashboardEmployee> createState() => _DashboardEmployeeState();
}

class _DashboardEmployeeState extends State<DashboardEmployee> {
  Employee? employee;
  bool isCheckedIn = false;
  bool isCheckedInWFH = false;
  bool isLoading = false;
  bool isLoadingEmployee = true;

  String workMode = "WFO";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadEmployee();
  }

  Future<void> _loadEmployee() async {
    try {
      final res = await http.get(
        Uri.parse(
          "http://localhost:8000/api/resource/Employee/${widget.user.id}",
        ),
        headers: {
          "Authorization": "token ${widget.user.token}",
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          employee = Employee.fromJson(data["data"]);
          isLoadingEmployee = false;
        });

        await _checkStatus();
      } else {
        debugPrint("❌ Gagal load employee: ${res.body}");
        setState(() => isLoadingEmployee = false);
      }
    } catch (e) {
      debugPrint("❌ Exception load employee: $e");
      setState(() => isLoadingEmployee = false);
    }
  }

  Future<void> _checkStatus() async {
    if (employee == null) return;

    try {
      final resWfo = await http.get(
        Uri.parse(
          "http://localhost:8000/api/method/hrpay.api.attendance.get_status?employee=${employee!.employeeName}&work_mode=WFO",
        ),
        headers: {
          "Authorization": "token ${widget.user.token}",
          "Content-Type": "application/json",
        },
      );

      final resWfh = await http.get(
        Uri.parse(
          "http://localhost:8000/api/method/hrpay.api.attendance.get_status?employee=${employee!.employeeName}&work_mode=WFH",
        ),
        headers: {
          "Authorization": "token ${widget.user.token}",
          "Content-Type": "application/json",
        },
      );

      if (resWfo.statusCode == 200) {
        final dwfo = jsonDecode(resWfo.body);
        if (dwfo["message"] is Map) {
          isCheckedIn = dwfo["message"]["status"] == "IN";
          if (isCheckedIn) workMode = "WFO";
        }
      }

      if (resWfh.statusCode == 200) {
        final dwfh = jsonDecode(resWfh.body);
        if (dwfh["message"] is Map) {
          isCheckedInWFH = dwfh["message"]["status"] == "IN";
          if (isCheckedInWFH) workMode = "WFH";
        }
      }

      setState(() {});
    } catch (e) {
      debugPrint("❌ Gagal cek status: $e");
    }
  }

  Future<void> _toggleAttendance() async {
    if (employee == null) return;

    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse(
          "http://localhost:8000/api/method/hrpay.api.attendance.check_in_karyawan",
        ),
        headers: {
          "Authorization": "token ${widget.user.token}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "employee": employee!.employeeName,
          "log_type": isCheckedIn ? "OUT" : "IN",
          "work_mode": "WFO",
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["message"]?["success"] == true) {
        setState(() {
          isCheckedIn = data["message"]["status"] == "IN";
          if (isCheckedIn) {
            isCheckedInWFH = false;
            workMode = "WFO";
          }
        });
      }

      PopupMessage.show(
        context: context,
        title: "WFO",
        message: data["message"]?["message"] ?? "Absensi WFO berhasil",
        success: data["message"]?["success"] == true,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Widget _buildDashboard() {
    if (isLoadingEmployee) {
      return const Center(child: CircularProgressIndicator());
    }
    if (employee == null) {
      return const Center(child: Text("❌ Data employee tidak ditemukan"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Karyawan
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                child: Text(employee!.employeeName.isNotEmpty
                    ? employee!.employeeName[0]
                    : "K"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hai, ${employee!.employeeName}!",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                        "${employee!.jobPosition ?? '-'} - ${employee!.department ?? '-'}",
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.notifications)),
            ],
          ),
          const SizedBox(height: 16),

          // Tombol Check-In/Out
          Row(
            children: [
              Expanded(
                child: AppButton(
                  type: isCheckedIn ? ButtonType.checkOut : ButtonType.checkIn,
                  text: isCheckedIn ? "Check-Out WFO" : "Check-In WFO",
                  isDisabled: isCheckedInWFH,
                  isLoading: isLoading,
                  onPressed: _toggleAttendance,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  type: ButtonType.checkIn,
                  text: "Check In/Out (WFH/A)",
                  isDisabled: isCheckedIn,
                  isLoading: false,
                  onPressed: () {
                    if (!isCheckedIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceForm(
                            employeeName: employee!.employeeName,
                            department: employee!.department,
                            user: widget.user,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sisa cuti
          Text("Sisa Cuti: ${employee!.leaveBalance ?? 0} hari",
              style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),

          // Hari Libur Mendatang
          const Text("Hari Libur Mendatang",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          if (employee!.upcomingHolidays == null ||
              employee!.upcomingHolidays!.isEmpty)
            const Text("Tidak ada data libur"),
          for (var libur in employee!.upcomingHolidays ?? [])
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(libur["holiday_name"] ?? "-"),
              trailing: Text(libur["holiday_date"] ?? "-"),
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
            builder: (context) => LeavePageKaryawan(user: widget.user)),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendancePage(user: widget.user),
        ),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Employee'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body:
          _selectedIndex == 0 ? _buildDashboard() : const SizedBox.shrink(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.time_to_leave), label: "Izin dan Cuti"),
          BottomNavigationBarItem(
              icon: Icon(Icons.lock_clock_rounded), label: "Kehadiran"),
        ],
      ),
    );
  }
}
