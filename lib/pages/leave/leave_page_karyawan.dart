import 'package:flutter/material.dart';
import '../../models/auth/user.dart';
import '../../models/leave/leave_request.dart';
import '../../services/leave_service.dart';
import 'leave_form.dart';
import 'leave_detail.dart';

class LeavePageKaryawan extends StatefulWidget {
  final User user;
  const LeavePageKaryawan({super.key, required this.user});

  @override
  State<LeavePageKaryawan> createState() => _LeavePageKaryawanState();
}

class _LeavePageKaryawanState extends State<LeavePageKaryawan> {
  final LeaveService _leaveService = LeaveService();

  List<LeaveRequest> _requests = [];
  bool _loading = false;

  // Filter
  int? _selectedMonth;
  int? _selectedYear;
  String? _selectedType;

  final List<String> _leaveTypes = const [
    "Tahunan",
    "Sakit",
    "Melahirkan",
    "Tidak Dibayar",
    "Izin Lainnya"
  ];

  final List<String> _monthNames = const [
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
    "Desember",
  ];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _loading = true);
    try {
      if (!widget.user.isEmployee) {
        setState(() => _requests = []);
        return;
      }

      final data = await _leaveService.fetchLeaveRequestsAuth(
        widget.user.role,
        widget.user.id,
      );

      if (mounted) {
        setState(() {
          _requests = data;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal load riwayat cuti: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeaveForm(user: widget.user),
      ),
    );
    if (result == true) {
      await _loadRequests(); // ✅ Tambahkan await di sini
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pengajuan cuti berhasil disimpan")),
        );
      }
    }
  }

  Future<void> _openDetail(LeaveRequest r) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => LeaveDetail(leaveRequest: r),
      ),
    );

    if (result == true) {
      await _loadRequests(); // ✅ Tambahkan await di sini
    }
  }

  @override
  Widget build(BuildContext context) {
    final years = _requests.map((r) => r.fromDate.year).toSet().toList()..sort();

    final filtered = _requests.where((r) {
      final matchesMonth =
          _selectedMonth == null || r.fromDate.month == _selectedMonth;
      final matchesYear =
          _selectedYear == null || r.fromDate.year == _selectedYear;
      final matchesType = _selectedType == null || r.leaveType == _selectedType;
      return matchesMonth && matchesYear && matchesType;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Cuti/Izin"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔹 PERBAIKAN: Gunakan SingleChildScrollView untuk menghindari overflow
          SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // 🔹 PERBAIKAN: Gunakan Column untuk layout mobile-friendly
                Column(
                  children: [
                    // Bulan
                    DropdownButtonFormField<int?>(
                      value: _selectedMonth,
                      decoration: const InputDecoration(
                        labelText: "Bulan",
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text("Semua Bulan"),
                        ),
                        ...List.generate(12, (i) {
                          final month = i + 1;
                          return DropdownMenuItem(
                            value: month,
                            child: Text(_monthNames[i]),
                          );
                        }),
                      ],
                      onChanged: (val) {
                        setState(() => _selectedMonth = val);
                      },
                    ),
                    const SizedBox(height: 8),

                    // Tahun
                    DropdownButtonFormField<int?>(
                      value: _selectedYear,
                      decoration: const InputDecoration(
                        labelText: "Tahun",
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text("Semua Tahun"),
                        ),
                        ...years.map(
                          (y) => DropdownMenuItem(
                            value: y,
                            child: Text("Tahun $y"),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() => _selectedYear = val);
                      },
                    ),
                    const SizedBox(height: 8),

                    // Jenis
                    DropdownButtonFormField<String?>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        labelText: "Jenis",
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text("Semua Jenis"),
                        ),
                        ..._leaveTypes.map(
                          (t) => DropdownMenuItem(value: t, child: Text(t)),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() => _selectedType = val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Tombol Ajukan
                SizedBox(
                  width: double.infinity, // ✅ Lebar penuh untuk mobile
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _openForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text(
                      "Ajukan Cuti/Izin",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                const Divider(thickness: 1),
              ],
            ),
          ),

          // 🔹 List Riwayat
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_note, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              "Belum ada riwayat cuti/izin",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadRequests,
                        child: ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, i) {
                            final r = filtered[i];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: ListTile(
                                title: Text(
                                  r.leaveType,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${r.fromDate.toString().split(' ')[0]} s/d ${r.toDate.toString().split(' ')[0]}",
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Status: ${r.status}",
                                      style: TextStyle(
                                        color: r.status == "Approved"
                                            ? Colors.green
                                            : r.status == "Rejected"
                                                ? Colors.red
                                                : Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => _openDetail(r),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}