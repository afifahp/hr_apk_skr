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
      _currentRequest.id.toString(),
      status,
      approver: widget.user.name,
    );

    setState(() => _isLoading = false);

   if (success) {
  setState(() {
    _currentRequest = LeaveRequest(
      id: _currentRequest.id,
      employeeName: _currentRequest.employeeName,
      jobPosition: _currentRequest.jobPosition,
      department: _currentRequest.department,
      descLeave: _currentRequest.descLeave,
      fromDate: _currentRequest.fromDate,
      toDate: _currentRequest.toDate,
      leaveType: _currentRequest.leaveType,
      status: status, // ✅ status update
      leaveApprover: widget.user.employeeName, // ✅ ambil nama user login
      halfDay: _currentRequest.halfDay,
      attachment: _currentRequest.attachment,
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
            Text("Departmen: ${_currentRequest.department}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Jenis Cuti/Izin: ${_currentRequest.leaveType}"),
            const SizedBox(height: 8),
            Text("Tanggal: ${_currentRequest.dateRange}"),  
            const SizedBox(height: 8),
            Text("Keterangan: ${_currentRequest.descLeave}"),
            const SizedBox(height: 8),
            if (_currentRequest.attachment!.isNotEmpty)
              Text("Lampiran: ${_currentRequest.attachment}"),  
            const SizedBox(height: 16),
            Text("Approver: ${_currentRequest.leaveApprover.isNotEmpty ? _currentRequest.leaveApprover : '-'}"),
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

            if (_currentRequest.leaveApprover.isNotEmpty)
              Text("Disetujui oleh: ${_currentRequest.leaveApprover}"),

            const Spacer(),

            // ✅ Kalau Chief & status masih Pending → tampilkan tombol Approve/Tolak
            if (isChief && _currentRequest.status == "Pending") ...[
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      type: ButtonType.accept, // ✅ tombol hijau "Terima"
                      isLoading: _isLoading,
                      onPressed: () => _updateStatus("Approved"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      type: ButtonType.decline, // ✅ tombol merah "Tolak"
                      isLoading: _isLoading,
                      onPressed: () => _updateStatus("Rejected"),
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
