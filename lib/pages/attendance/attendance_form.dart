import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../widgets/app_button.dart';
import 'dart:async';

import 'attendance_req_list.dart';
import '../../models/auth/user.dart';

class AttendanceForm extends StatefulWidget {
  final String employeeName;
  final String department;
  final User user;

  const AttendanceForm({
    super.key,
    required this.employeeName,
    required this.department,
    required this.user,
  });

  @override
  State<AttendanceForm> createState() => _AttendanceFormState();
}

class _AttendanceFormState extends State<AttendanceForm> {
  final TextEditingController _descController = TextEditingController();
  bool isLoading = false;

  late DateTime now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();

    // update setiap 1 detik
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _descController.dispose();
    super.dispose();
  }

  void _submitRequest() async {
    setState(() => isLoading = true);

    // simulasi delay submit
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => isLoading = false);

      // 🔹 Setelah submit → langsung balik ke dashboard
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Permintaan WFH/A"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama
            Text("Nama:   ${widget.user.employeeName}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),

            // Dept
            Text("Departmen :   ${widget.user.department}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            // Tanggal & Jam (real-time)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${now.day} ${_monthName(now.month)} ${now.year}",
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')} ${now.hour >= 12 ? "pm" : "am"}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Keterangan
            const Text("Keterangan:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              dashPattern: const [6.0, 3.0],
              color: Colors.black54,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Isi keterangan di sini...",
                  ),
                ),
              ),
            ),
            const Spacer(),

            // Tombol Ajukan Permintaan
            SizedBox(
              width: double.infinity,
              child: AppButton(
                type: ButtonType.ajukan,
                isLoading: isLoading,
                onPressed: _submitRequest,
                label: "Ajukan Permintaan", // ✅ ubah label
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const bulan = [
      "",
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
    return bulan[month];
  }
}
