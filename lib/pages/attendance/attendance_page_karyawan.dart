// file: attendance_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/attendance/attendance.dart';
import '../../models/auth/user.dart';

class AttendancePageKaryawan extends StatefulWidget {
  final User user;

  const AttendancePageKaryawan({
    super.key,
    required this.user,
  });

  @override
  State<AttendancePageKaryawan> createState() => _AttendancePageKaryawanState();
}

class _AttendancePageKaryawanState extends State<AttendancePageKaryawan> {
  late Future<Map<String, dynamic>> _futureAttendances;
  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedStatus;
  List<Attendance> _allAttendances = [];

  @override
  void initState() {
    super.initState();
    _futureAttendances = _fetchAttendanceData();
  }

  Future<Map<String, dynamic>> _fetchAttendanceData() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:8000/api/method/hrpay.api.attendance.get_all_attendance_employe"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'token b531f47fc2742a1:3ae43feb9d18551', // ✅ tambahin auth
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("API Response: $data");
        
        if (data['message'] != null && data['message']['status'] == 'success') {
          // Extract employee name
          final employeeName = data['message']['employee_name'] ?? '';
          
          // Extract attendance data
          final List<dynamic> attendanceData = data['message']['data'] ?? [];
          
          // Convert to Attendance objects
          _allAttendances = attendanceData.map((item) {
            return Attendance.fromJson(item);
          }).toList();
          
          return {
            'status': 'success',
            'employee_name': employeeName,
            'attendances': _allAttendances,
          };
        } else {
          throw Exception('API returned error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load attendance data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching attendance data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusOptions = ["Present", "On Leave", "Absent", "Work From Home", "Half Day"];
    final months = [
      "Januari","Februari","Maret","April","Mei","Juni",
      "Juli","Agustus","September","Oktober","November","Desember"
    ];
    final years = List.generate(5, (i) => (DateTime.now().year - i).toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Kehadiran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Bulan
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Text("Bulan"),
                        value: _selectedMonth,
                        isExpanded: true,
                        items: months.asMap().entries.map((entry) {
                          final idx = entry.key + 1;
                          final name = entry.value;
                          return DropdownMenuItem(
                            value: idx.toString().padLeft(2, "0"),
                            child: Text(name),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedMonth = val),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Tahun
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Text("Tahun"),
                        value: _selectedYear,
                        isExpanded: true,
                        items: years
                            .map((y) =>
                                DropdownMenuItem(value: y, child: Text(y)))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedYear = val),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Jenis
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Text("Status"),
                        value: _selectedStatus,
                        isExpanded: true,
                        items: statusOptions
                            .map((s) =>
                                DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedStatus = val),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Reset Button
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedMonth = null;
                        _selectedYear = null;
                        _selectedStatus = null;
                      });
                    },
                    child: const Text("Reset"),
                  ),
                ),
              ],
            ),
          ),

          // Attendance List
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _futureAttendances,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Error: ${snapshot.error}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!['status'] != 'success') {
                  return const Center(
                    child: Text("Tidak ada data kehadiran yang ditemukan"),
                  );
                }

                final employeeName = snapshot.data!['employee_name'] ?? '';
                List<Attendance> attendances = _allAttendances;

                // Apply Filters
                attendances = attendances.where((att) {
                  final attendanceDate = att.attendanceDate;
                  
                  final matchesMonth = _selectedMonth == null ||
                      attendanceDate.month.toString().padLeft(2, '0') == _selectedMonth;
                  
                  final matchesYear = _selectedYear == null ||
                      attendanceDate.year.toString() == _selectedYear;
                  
                  final matchesStatus = _selectedStatus == null ||
                      att.status == _selectedStatus;
                  
                  return matchesMonth && matchesYear && matchesStatus;
                }).toList();

                if (attendances.isEmpty) {
                  return const Center(
                    child: Text("Tidak ada data kehadiran dengan filter yang dipilih"),
                  );
                }

                // Sort by date (newest first)
                attendances.sort((a, b) => b.attendanceDate.compareTo(a.attendanceDate));

                return Column(
                  children: [
                    // Employee Name Header
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        employeeName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    // Attendance List
                    Expanded(
                      child: ListView.builder(
                        itemCount: attendances.length,
                        itemBuilder: (context, index) {
                          final attendance = attendances[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: ListTile(
                              leading: _getStatusIcon(attendance.status),
                              title: Text(
                                _getStatusLabel(attendance.status),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(attendance.status),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_formatDate(attendance.attendanceDate)),
                                  if (attendance.intime != null)
                                    Text("Masuk: ${attendance.intime}"),
                                  if (attendance.checkOut != null)
                                    Text("Keluar: ${attendance.checkOut}"),
                                  if (attendance.intime == null && attendance.checkOut == null)
                                    const Text("Tidak ada catatan waktu"),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () {
                                  _showAttendanceDetail(attendance);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Icon _getStatusIcon(String status) {
    switch (status) {
      case 'Present':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'Half Day':
        return const Icon(Icons.access_time, color: Colors.orange);
      case 'On Leave':
        return const Icon(Icons.beach_access, color: Colors.blue);
      case 'Work From Home':
        return const Icon(Icons.home, color: Colors.purple);
      case 'Absent':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.help_outline, color: Colors.grey);
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'Present':
        return 'Hadir';
      case 'Half Day':
        return 'Setengah Hari';
      case 'On Leave':
        return 'Cuti';
      case 'Work From Home':
        return 'WFH';
      case 'Absent':
        return 'Alpa';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Half Day':
        return Colors.orange;
      case 'On Leave':
        return Colors.blue;
      case 'Work From Home':
        return Colors.purple;
      case 'Absent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  void _showAttendanceDetail(Attendance attendance) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Detail Kehadiran - ${_formatDate(attendance.attendanceDate)}"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Status: ${_getStatusLabel(attendance.status)}"),
                const SizedBox(height: 8),
                Text("Waktu Masuk: ${attendance.intime ?? '-'}"),
                Text("Waktu Keluar: ${attendance.checkOut ?? '-'}"),
                const SizedBox(height: 8),
                Text("ID Absensi: ${attendance.id}"),
                Text("ID Karyawan: ${attendance.employee}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }
}
