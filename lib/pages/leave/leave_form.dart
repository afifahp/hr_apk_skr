import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/auth/user.dart';
import '../../models/leave/leave_request.dart';
import '../../services/leave_service.dart';

class LeaveForm extends StatefulWidget {
  final User user;
  final LeaveRequest? request;

  const LeaveForm({super.key, required this.user, this.request});

  @override
  State<LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _approverController = TextEditingController();
  final _departmentController = TextEditingController();

  final LeaveService _leaveService = LeaveService();

  String? _leaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _halfDay = false;

  // Attachment (cross-platform)
  String? _fileName;
  String? _filePath; // mobile/desktop
  Uint8List? _fileBytes; // web

  bool _isLoading = false;

  final List<String> _leaveTypes = const [
    "Tahunan",
    "Sakit",
    "Melahirkan",
    "Tidak Dibayar",
    "Izin Lainnya"
  ];

  @override
  void initState() {
    super.initState();
    _approverController.text = widget.user.leaveApprover ?? "-";
    _departmentController.text = widget.user.department ?? "-";

    if (widget.request != null) {
      final r = widget.request!;
      _descController.text = r.descLeave;
      _approverController.text = r.leaveApprover;
      _departmentController.text = r.department ?? "-";
      _leaveType = r.leaveType;
      _startDate = r.fromDate;
      _endDate = r.toDate;
      _halfDay = r.halfDay == 1;
      _fileName = r.attachment != null ? r.attachment!.split('/').last : null;
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1),
    );
    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _pickAttachment() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: kIsWeb,
    );
    if (result == null || result.files.isEmpty) return;

    final f = result.files.single;
    setState(() {
      _fileName = f.name;
      if (kIsWeb) {
        _fileBytes = f.bytes;
        _filePath = null;
      } else {
        _filePath = f.path;
        _fileBytes = null;
      }
    });
  }

  Future<void> _submitLeave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih tanggal mulai")),
      );
      return;
    }
    if (!_halfDay && _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih tanggal selesai")),
      );
      return;
    }

    setState(() => _isLoading = true);

    if (widget.request == null) {
      final newRequest = LeaveRequest(
        id: 0,
        employeeName: widget.user.employeeName,
        jobPosition: widget.user.jobPosition ?? "",
        department: _departmentController.text.isNotEmpty
            ? _departmentController.text
            : widget.user.department ?? "-",
        descLeave: _leaveType == "Melahirkan" ? "" : _descController.text,
        fromDate: _startDate!,
        toDate: _halfDay ? _startDate! : _endDate!,
        leaveType: _leaveType ?? "Tahunan",
        status: "Pending",
        leaveApprover: _approverController.text.isNotEmpty
        ? _approverController.text
        : widget.user.leaveApprover ?? "-",
        halfDay: _halfDay ? 1 : 0,
        attachment: _filePath,
      );

      final success = await _leaveService.createLeaveRequest(
        newRequest,
        filePath: _filePath,
        fileBytes: _fileBytes,
        fileName: _fileName,
      );

      setState(() => _isLoading = false);

      if (!mounted) return;
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
    } else {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gunakan tombol Approve / Decline")),
      );
    }
  }

  Future<void> _submitChief(String status) async {
    if (widget.request == null) return;

    setState(() => _isLoading = true);

    final ok = await _leaveService.updateLeaveStatus(
      widget.request!.id.toString(),
      status,
      approver: widget.user.employeeName,
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (ok) {
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
    final isChief = widget.user.role.toLowerCase() == "chief";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengajuan Cuti/Izin"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.user.employeeName,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _departmentController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Departemen",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _leaveType,
                items: _leaveTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: isChief
                    ? null
                    : (val) {
                        setState(() {
                          _leaveType = val;
                          if (val == "Melahirkan") _descController.clear();
                        });
                      },
                decoration: const InputDecoration(
                  labelText: "Jenis Izin",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null ? "Pilih jenis izin" : null,
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(
                  _startDate == null
                      ? (_halfDay ? "Pilih Tanggal" : "Pilih Tanggal Mulai")
                      : (_halfDay
                          ? "Tanggal: ${_startDate!.toString().split(' ')[0]}"
                          : "Mulai: ${_startDate!.toString().split(' ')[0]}"),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: isChief ? null : () => _pickDate(true),
              ),
              const SizedBox(height: 8),
              if (!_halfDay)
                ListTile(
                  title: Text(
                    _endDate == null
                        ? "Pilih Tanggal Selesai"
                        : "Selesai: ${_endDate!.toString().split(' ')[0]}",
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: isChief ? null : () => _pickDate(false),
                ),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: _halfDay,
                onChanged: isChief
                    ? null
                    : (v) => setState(() {
                          _halfDay = v ?? false;
                          if (_halfDay) _endDate = null;
                        }),
                title: const Text("Setengah Hari"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                enabled: !isChief && _leaveType != "Melahirkan",
                decoration: const InputDecoration(
                  labelText: "Keterangan (opsional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _approverController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Approver",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _fileName == null
                          ? "Belum ada lampiran"
                          : "Lampiran: $_fileName",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: isChief ? null : _pickAttachment,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (!isChief)
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitLeave,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(_isLoading ? "Mengirim..." : "Ajukan"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24), // lebih tebal
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // 8–10px radius
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600, // biar tulisannya lebih tegas
                    ),
                  ),
            ) 
              else
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed:
                            _isLoading ? null : () => _submitChief("Approved"),
                        child: const Text("Approve"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed:
                            _isLoading ? null : () => _submitChief("Declined"),
                        child: const Text("Decline"),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
