import 'package:flutter/material.dart';
import '../../models/auth/user.dart';
import '../../models/leave/leave_request.dart';
import '../../services/leave_service.dart';
import 'leave_form.dart';
import 'leave_approval.dart';

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

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);

    try {
      final data = await _leaveService.fetchLeaveRequests(
        widget.user.role,
        widget.user.id,
        divisionId: widget.user.subRole, // kalau chief, bisa kirim division id
      );
      setState(() {
        _requests = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal load data: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _openForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeaveForm(user: widget.user),
      ),
    );

    if (result == true) {
      _loadRequests(); // refresh list setelah submit
    }
  }

  void _openApproval(LeaveRequest request) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeaveApprovalPage(user: widget.user, request: request),
      ),
    );

    if (result == true) {
      _loadRequests(); // refresh setelah approve/reject
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmployee = widget.user.isEmployee;

    return Scaffold(
      appBar: AppBar(title: const Text("Pengajuan Cuti/Izin")),
      floatingActionButton: isEmployee
          ? FloatingActionButton(
              onPressed: _openForm,
              child: const Icon(Icons.add),
            )
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _requests.isEmpty
              ? const Center(child: Text("Belum ada pengajuan cuti/izin"))
              : RefreshIndicator(
                  onRefresh: _loadRequests,
                  child: ListView.builder(
                    itemCount: _requests.length,
                    itemBuilder: (context, index) {
                      final req = _requests[index];
                      return Card(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(req.employeeName),
                          subtitle: Text(
                            "${req.dateRange}\nAlasan: ${req.reason}",
                          ),
                          isThreeLine: true,
                          trailing: Text(
                            req.status,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: req.status == "Approved"
                                  ? Colors.green
                                  : req.status == "Rejected"
                                      ? Colors.red
                                      : Colors.orange,
                            ),
                          ),
                          onTap: () => _openApproval(req),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
