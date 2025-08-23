import 'package:flutter/material.dart';
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
      _currentRequest.id,
      status,
      approver: widget.user.name,
    );

    setState(() => _isLoading = false);

    if (success) {
      setState(() {
        _currentRequest = LeaveRequest(
          id: _currentRequest.id,
          employeeId: _currentRequest.employeeId,
          employeeName: _currentRequest.employeeName,
          reason: _currentRequest.reason,
          startDate: _currentRequest.startDate,
          endDate: _currentRequest.endDate,
          status: status,
          approver: widget.user.name,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pengajuan ${status.toLowerCase()}")),
      );
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
            Text("Tanggal: ${_currentRequest.dateRange}"),
            const SizedBox(height: 8),
            Text("Alasan: ${_currentRequest.reason}"),
            const SizedBox(height: 8),
            Text("Status: ${_currentRequest.status}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _currentRequest.status == "Approved"
                      ? Colors.green
                      : _currentRequest.status == "Rejected"
                          ? Colors.red
                          : Colors.orange,
                )),
            const SizedBox(height: 16),

            if (_currentRequest.approver != null)
              Text("Disetujui oleh: ${_currentRequest.approver}"),

            const Spacer(),

            // ✅ Kalau Chief & status masih Pending → tampilkan tombol Approve/Tolak
            if (isChief && _currentRequest.status == "Pending") ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed:
                          _isLoading ? null : () => _updateStatus("Approved"),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Setujui"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed:
                          _isLoading ? null : () => _updateStatus("Rejected"),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Tolak"),
                    ),
                  ),
                ],
              ),
            ],

            // ✅ Kalau Chief & status sudah final → tampilkan info selesai
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
