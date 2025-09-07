import 'package:flutter/material.dart';
import '../../models/auth/user.dart';
import '../../models/leave/leave_request.dart';
import '../../services/leave_service.dart';
import 'leave_approval.dart';
import 'leave_detail.dart';

class LeavePage extends StatefulWidget {
  final User user;

  const LeavePage({super.key, required this.user});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final LeaveService _leaveService = LeaveService();
  List<LeaveRequest> _requests = [];
  bool _isLoading = true;

  String _selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);

    try {
      List<LeaveRequest> data = [];

      // 🔹 PERBAIKAN: Gunakan getter, bukan cek string langsung
      if (widget.user.isChief) {
        // Chief Officer → ambil berdasarkan department
        data = await _leaveService.fetchLeaveByDepartment(widget.user.department);
      } else if (widget.user.isHR) {
        // HR → ambil semua request
        data = await _leaveService.fetchLeaveRequests(
          widget.user.role,
          widget.user.id,
        );
      } else if (widget.user.isEmployee) {
        // Employee → ambil request milik sendiri
        data = await _leaveService.fetchLeaveRequestsAuth(
          widget.user.role,
          widget.user.id,
        );
      }

      setState(() {
        _requests = data;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal load data: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openRequest(LeaveRequest request) async {
  final isChief = widget.user.isChief;

  if (isChief &&
      (request.status.toLowerCase() == "open" ||
          request.status.toLowerCase() == "pending")) {
    // 🔹 PERBAIKAN: Gunakan await dan tangkap return value dengan benar
    final updatedRequest = await Navigator.push<LeaveRequest>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LeaveApprovalPage(user: widget.user, request: request),
      ),
    );

    if (updatedRequest != null) {
      // 🔹 PERBAIKAN: Pastikan ID matching sebelum update
      setState(() {
        final index = _requests.indexWhere((r) => r.id == updatedRequest.id);
        if (index != -1) {
          _requests[index] = updatedRequest;
        } else {
          // Jika tidak ditemukan, mungkin perlu reload dari API
          _loadRequests();
        }
      });
    }
  } else {
    // HR + Employee → lihat detail
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeaveDetail(leaveRequest: request),
      ),
    );
  }
}

  List<LeaveRequest> get _filteredRequests {
    if (_selectedFilter == "All") return _requests;
    return _requests
        .where((r) => r.status.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengajuan Cuti/Izin")),
      body: Column(
        children: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedFilter,
              items: const [
                DropdownMenuItem(value: "All", child: Text("Semua")),
                DropdownMenuItem(value: "Pending", child: Text("Pending")),
                DropdownMenuItem(value: "Approved", child: Text("Approved")),
                DropdownMenuItem(value: "Rejected", child: Text("Rejected")),
                DropdownMenuItem(value: "Open", child: Text("Open")),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedFilter = val);
                }
              },
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredRequests.isEmpty
                    ? const Center(
                        child: Text("Belum ada pengajuan cuti/izin"))
                    : RefreshIndicator(
                        onRefresh: _loadRequests,
                        child: ListView.builder(
                          itemCount: _filteredRequests.length,
                          itemBuilder: (context, index) {
                            final req = _filteredRequests[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: ListTile(
                                title: Text(req.employeeName),
                                subtitle: Text(
                                  "${req.dateRange}\n"
                                  "Posisi: ${req.jobPosition}\n"
                                  "Departemen: ${req.department}\n"
                                  "Alasan: ${req.descLeave}",
                                ),
                                isThreeLine: true,
                                trailing: Text(
                                  req.status == "Rejected"
                                      ? "Declined"
                                      : req.status,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: req.status == "Approved"
                                        ? Colors.green
                                        : req.status == "Rejected"
                                            ? Colors.red
                                            : Colors.orange,
                                  ),
                                ),
                                onTap: () => _openRequest(req),
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