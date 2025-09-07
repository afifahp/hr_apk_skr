import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';
import '../../models/auth/user.dart';
import '../../models/leave/leave_request.dart';
import '../../services/leave_service.dart';

class LeaveApprovalPage extends StatefulWidget {
  final User user;
  final LeaveRequest request;

  const LeaveApprovalPage({
    super.key,
    required this.user,
    required this.request,
  });

  @override
  State<LeaveApprovalPage> createState() => _LeaveApprovalPageState();
}

class _LeaveApprovalPageState extends State<LeaveApprovalPage> {
  bool _isLoading = false;
  late LeaveRequest _currentRequest;
  final LeaveService _leaveService = LeaveService();

  @override
  void initState() {
    super.initState();
    _currentRequest = widget.request;
  }

  Future<void> _updateStatus(String status) async {
    setState(() => _isLoading = true);

    final success = await _leaveService.updateLeaveStatus(
      _currentRequest.id.toString(), // ✅ pastikan String
      status,
      approver: widget.user.employeeName,
    );

    setState(() => _isLoading = false);

    if (success) {
      final updatedRequest = _currentRequest.copyWith(
        status: status,
        leaveApprover: widget.user.employeeName,
      );

      setState(() {
        _currentRequest = updatedRequest;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pengajuan ${status.toLowerCase()}")),
      );

      Navigator.pop(context, updatedRequest);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal update status")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isChief = widget.user.isChief;

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pengajuan Cuti/Izin")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama: ${_currentRequest.employeeName}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Departemen: ${_currentRequest.department}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Jenis Cuti/Izin: ${_currentRequest.leaveType}"),
            const SizedBox(height: 8),
            Text("Tanggal: ${_currentRequest.dateRange}"),
            const SizedBox(height: 8),
            Text("Keterangan: ${_currentRequest.descLeave}"),
            const SizedBox(height: 8),
            if ((_currentRequest.attachment ?? "").isNotEmpty)
              Text("Lampiran: ${_currentRequest.attachment}"),
            const SizedBox(height: 16),
            Text("Approver: ${_currentRequest.leaveApprover.isNotEmpty ? _currentRequest.leaveApprover : '-'}"),
            const SizedBox(height: 8),
            Text("Status: ${_currentRequest.status}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _currentRequest.status == "Accepted"
                      ? Colors.green
                      : _currentRequest.status == "Rejected"
                          ? Colors.red
                          : Colors.orange,
                )),
            const SizedBox(height: 8),
            Text("ID: ${_currentRequest.id}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                )),
            const SizedBox(height: 16),
            const Spacer(),

            // 🔹 Tombol Approve / Reject
            if (isChief && _currentRequest.status == "Pending") ...[
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      type: ButtonType.accept,
                      label: "Setujui",
                      isLoading: _isLoading,
                      onPressed: () => _updateStatus("Accepted"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      type: ButtonType.decline,
                      label: "Tolak",
                      isLoading: _isLoading,
                      onPressed: () => _updateStatus("Rejected"),
                    ),
                  ),
                ],
              ),
            ],
            if (isChief && _currentRequest.status != "Pending")
              Center(
                child: Text(
                  "✅ Pengajuan sudah ${_currentRequest.status}",
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
