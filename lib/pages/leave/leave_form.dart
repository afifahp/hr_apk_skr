import 'package:flutter/material.dart';
import '../../models/auth/user.dart';
import '../../models/leave/leave_request.dart';
import '../../services/leave_service.dart';

class LeaveForm extends StatefulWidget {
  final User user;
  final LeaveRequest? request; // kalau CO buka request existing

  const LeaveForm({super.key, required this.user, this.request});

  @override
  State<LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  final _reasonController = TextEditingController();
  DateTimeRange? _selectedDates;
  bool _isLoading = false;

  final LeaveService _leaveService = LeaveService();

  @override
  void initState() {
    super.initState();
    if (widget.request != null) {
      _reasonController.text = widget.request!.reason;
    }
  }

  Future<void> _submitEmployee() async {
    if (_selectedDates == null || _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data dulu")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final newRequest = LeaveRequest(
      id: 0, // backend yg generate id
      employeeId: widget.user.id,
      employeeName: widget.user.name,
      reason: _reasonController.text,
      startDate: _selectedDates!.start,
      endDate: _selectedDates!.end,
      status: "Pending",
    );

    final success = await _leaveService.createLeaveRequest(newRequest);

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pengajuan berhasil dikirim")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengajukan cuti")),
      );
    }
  }

  Future<void> _submitChief(String status) async {
    if (widget.request == null) return;

    setState(() => _isLoading = true);

    final success = await _leaveService.updateLeaveStatus(
      widget.request!.id,
      status,
      approver: widget.user.name,
    );

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pengajuan ${status.toLowerCase()}")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal update status")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmployee = widget.user.isEmployee;
    final isChief = widget.user.isChief;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEmployee
            ? "Pengajuan Cuti/Izin"
            : "Persetujuan Pengajuan Cuti"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (isEmployee) ...[
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: "Alasan Cuti/Izin",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(_selectedDates == null
                        ? "Pilih tanggal"
                        : "${_selectedDates!.start.toString().split(' ')[0]} - ${_selectedDates!.end.toString().split(' ')[0]}"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDates = picked;
                        });
                      }
                    },
                    child: const Text("Pilih"),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitEmployee,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Ajukan"),
              ),
            ],
            if (isChief && widget.request != null) ...[
              ListTile(
                title: Text("Nama: ${widget.request!.employeeName}"),
                subtitle: Text(
                    "Tanggal: ${widget.request!.dateRange}\nAlasan: ${widget.request!.reason}"),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: _isLoading ? null : () => _submitChief("Approved"),
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
                      onPressed: _isLoading ? null : () => _submitChief("Rejected"),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Tolak"),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
