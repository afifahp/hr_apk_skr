import 'package:flutter/material.dart';
import '../../models/auth/user.dart';
import '../../models/leave/leave_request.dart';
import '../../services/leave_service.dart';
import 'leave_form.dart';

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
  int? _selectedMonth; // null = semua bulan
  int? _selectedYear; // null = semua tahun
  String? _selectedType; // null = semua jenis

  final List<String> _leaveTypes = const [
    "Tahunan",
    "Sakit",
    "Melahirkan",
    "Tidak Dibayar",
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
      final data = await _leaveService.fetchLeaveRequests(
        widget.user.role,
        widget.user.id,
      );

      setState(() {
        _requests = data;
      });
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
      _loadRequests(); // refresh list kalau ada submit baru
    }
  }

  @override
  Widget build(BuildContext context) {
    // ambil semua tahun dari data
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
          // Filter
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Bulan
                Expanded(
                  child: DropdownButton<int?>(
                    isExpanded: true,
                    value: _selectedMonth,
                    hint: const Text("Semua Bulan"),
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
                ),
                const SizedBox(width: 8),

                // Tahun
                Expanded(
                  child: DropdownButton<int?>(
                    isExpanded: true,
                    value: _selectedYear,
                    hint: const Text("Semua Tahun"),
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
                ),
                const SizedBox(width: 8),

                // Jenis
                Expanded(
                  child: DropdownButton<String?>(
                    isExpanded: true,
                    value: _selectedType,
                    hint: const Text("Semua Jenis"),
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
                ),
              ],
            ),
          ),

          // List Riwayat
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(child: Text("Belum ada riwayat cuti/izin"))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final r = filtered[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: ListTile(
                              title: Text("${r.leaveType} (${r.status})"),
                              subtitle: Text(
                                "${r.fromDate.toString().split(' ')[0]} "
                                "s/d ${r.toDate.toString().split(' ')[0]}",
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        LeaveForm(user: widget.user, request: r),
                                  ),
                                );
                                if (result == true) {
                                  _loadRequests();
                                }
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
