import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'; //flutter kalo frappe gagal

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
  // late final FaceDetector _faceDetector;     //non-frappe

  // /// ✅ Konfigurasi area kantor (contoh)
  // static const double _officeLat = -6.200000;     // ganti koordinat kantor
  // static const double _officeLng = 106.816666;
  // static const double _radiusMeter = 150;         // radius geofence

  // @override
  // void initState() {
  //   super.initState();
  //   _faceDetector = FaceDetector(
  //     options: FaceDetectorOptions(
  //       performanceMode: FaceDetectorMode.accurate,
  //       enableContours: false,
  //       enableClassification: true, // supaya bisa cek eyesOpenProb, smilingProb (opsional)
  //     ),
  //   );
  // }

  // @override
  // void dispose() {
  //   _faceDetector.close();
  //   super.dispose();
  // }

  // /// 🔐 Minta izin lokasi kalau belum
  // Future<bool> _ensureLocationPermission() async {
  //   var perm = await Geolocator.checkPermission();
  //   if (perm == LocationPermission.denied ||
  //       perm == LocationPermission.deniedForever) {
  //     perm = await Geolocator.requestPermission();
  //   }
  //   return perm == LocationPermission.always ||
  //       perm == LocationPermission.whileInUse;
  // }

  // /// 📍 Cek jarak dari kantor (meter)
  // double _distanceToOffice(Position pos) {
  //   return Geolocator.distanceBetween(
  //     pos.latitude, pos.longitude, _officeLat, _officeLng,
  //   );
  // }

  // /// 🤳 Ambil foto selfie
  // Future<XFile?> _takeSelfie() async {
  //   return _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front, imageQuality: 85);
  // }

  // /// 🙂 Minimal validasi wajah: ada wajah tunggal & cukup besar
  // Future<bool> _hasValidFace(File imageFile) async {
  //   final input = InputImage.fromFile(imageFile);
  //   final faces = await _faceDetector.processImage(input);

  //   if (faces.isEmpty) return false;
  //   // jika lebih dari 1 wajah → tolak (opsional)
  //   if (faces.length > 1) return false;

  //   // cek ukuran bounding box relatif (opsional)
  //   final box = faces.first.boundingBox;
  //   final area = box.width * box.height;
  //   if (area < 80 * 80) return false; // terlalu kecil → kemungkinan bukan selfie dekat

  //   // opsional: cek mata terbuka / senyum (kalau plugin menyediakan)
  //   // final f = faces.first;
  //   // if ((f.leftEyeOpenProbability ?? 0) < 0.3 && (f.rightEyeOpenProbability ?? 0) < 0.3) return false;

  //   return true;
  // }

  // /// 🧠 LOGIC FLUTTER-ONLY (tanpa Frappe)
  // Future<void> _toggleAttendanceLocal() async {
  //   setState(() => isLoading = true);
  //   try {
  //     // 1) Izin lokasi
  //     final granted = await _ensureLocationPermission();
  //     if (!granted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("❌ Izin lokasi ditolak")),
  //       );
  //       return;
  //     }

  //     // 2) Ambil posisi
  //     final pos = await Geolocator.getCurrentPosition();
  //     final distance = _distanceToOffice(pos);
  //     if (distance > _radiusMeter) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("❌ Di luar area kantor (${distance.toStringAsFixed(0)} m)")),
  //       );
  //       return;
  //     }

  //     // 3) Ambil selfie
  //     final photo = await _takeSelfie();
  //     if (photo == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("⚠️ Foto wajah wajib diambil")),
  //       );
  //       return;
  //     }

  //     // 4) Deteksi wajah lokal
  //     final isFaceOk = await _hasValidFace(File(photo.path));
  //     if (!isFaceOk) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("❌ Wajah tidak terdeteksi/invalid")),
  //       );
  //       return;
  //     }

  //     // 5) Toggle status lokal
  //     setState(() => isCheckedIn = !isCheckedIn);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(isCheckedIn
  //             ? "✅ Check-in (local) sukses"
  //             : "✅ Check-out (local) sukses"),
  //       ),
  //     );

  //     // (Opsional) Simpan log lokal, timestamp, path foto, koordinat, dll.
  //     // pakai SharedPreferences / sembarang storage.

  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("⚠️ Error (local): $e")),
  //     );
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }

  // // Versi Frappe-mu tetap bisa dipertahankan di sini, tinggal panggil yg mana.
  // // Future<void> _toggleAttendance() async { ... } // <= versi API

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
