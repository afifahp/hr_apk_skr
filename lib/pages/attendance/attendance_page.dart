// file: attendance_page.dart
import 'package:flutter/material.dart';
import '../../models/attendance/attendance.dart';
import '../../models/auth/user.dart';
import '../../services/attendance_service.dart';

class AttendancePage extends StatefulWidget {
  final User user;

  const AttendancePage({
    super.key,
    required this.user,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late Future<List<Attendance>> _futureAttendances;
  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();

    // 🔹 PERBAIKAN: Gunakan getter, bukan cek string langsung
    if (widget.user.isHR) {
      _futureAttendances = AttendanceService.fetchAllAttendance();
    } else if (widget.user.isChief) {
      _futureAttendances =
          AttendanceService.fetchAttendanceByDepartment(widget.user.department);
    } else {
      // selain HR & Chief Officer, tidak fetch apa-apa
      _futureAttendances = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusOptions = ["Hadir", "Half Day", "Cuti", "Work From Home", "Alpa"];
    final months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    final years =
        List.generate(5, (i) => (DateTime.now().year - i).toString());

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
                        hint: const Text("Jenis"),
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
            child: FutureBuilder<List<Attendance>>(
              future: _futureAttendances,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                var attendances = snapshot.data ?? [];

                // Apply Filters
                attendances = attendances.where((att) {
                  final matchesMonth = _selectedMonth == null ||
                      att.attendanceDate.month
                              .toString()
                              .padLeft(2, '0') ==
                          _selectedMonth;
                  final matchesYear = _selectedYear == null ||
                      att.attendanceDate.year.toString() == _selectedYear;
                  final matchesStatus = _selectedStatus == null ||
                      att.statusLabel == _selectedStatus;
                  return matchesMonth && matchesYear && matchesStatus;
                }).toList();

                if (attendances.isEmpty) {
                  return const Center(child: Text("Belum ada data kehadiran"));
                }

                return ListView.builder(
                  itemCount: attendances.length,
                  itemBuilder: (context, index) {
                    final attendance = attendances[index];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        "Employee: ${attendance.employeeName} - ${attendance.statusLabel}",
                      ),
                      subtitle: Text(
                        _formatDate(attendance.attendanceDate),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/attendance/attendance_detail',
                            arguments: attendance,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}