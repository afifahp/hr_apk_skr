import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/auth/user.dart';
import '../../widgets/app_button.dart';

class DashboardEmployee extends StatefulWidget {
  final User user;

  const DashboardEmployee({super.key, required this.user});

  @override
  State<DashboardEmployee> createState() => _DashboardEmployeeState();
}

class _DashboardEmployeeState extends State<DashboardEmployee> {
  bool isCheckedIn = false;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _toggleAttendance() async {
    setState(() => isLoading = true);

    try {
      // 🔹 1. Minta izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("❌ Izin lokasi ditolak")),
          );
          return;
        }
      }

      // 🔹 2. Ambil lokasi
      Position pos = await Geolocator.getCurrentPosition();

      // 🔹 3. Ambil foto wajah (kamera)
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Foto wajah wajib diambil")),
        );
        return;
      }

      // 🔹 4. Upload ke backend (Frappe)
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("https://your-frappe-api.com/api/method/attendance.toggle"),
      );

      request.headers.addAll({
        "Authorization": "token ${widget.user.token}", // kalau ada token
      });

      request.fields.addAll({
        "employee_id": widget.user.id,
        "lat": pos.latitude.toString(),
        "lng": pos.longitude.toString(),
        "action": isCheckedIn ? "checkout" : "checkin",
      });

      request.files.add(await http.MultipartFile.fromPath("photo", photo.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if (response.statusCode == 200 && data["ok"] == true) {
        setState(() => isCheckedIn = !isCheckedIn);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "✅ Absensi berhasil")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${data["message"] ?? "Gagal absensi"}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error absensi: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppButton(
              type: isCheckedIn ? ButtonType.checkOut : ButtonType.checkIn,
              onPressed: _toggleAttendance,
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }
}
