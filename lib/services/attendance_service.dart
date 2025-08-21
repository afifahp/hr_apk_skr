import 'dart:convert';
import 'package:http/http.dart' as http; //ini ke local?
import '../models/attendance/attendance.dart';
import '../models/attendance/attendance_summary.dart';

class AttendanceService {
  final String baseUrl;
  final String token; // JWT atau session key Frappe

  AttendanceService({required this.baseUrl, required this.token});

  // 🔹 Helper untuk header request
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // 🔹 Create Attendance (karyawan submit absen)
  Future<Attendance?> createAttendance(Attendance attendance) async {
    final url = Uri.parse('$baseUrl/api/resource/Attendance');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(attendance.toJson()),
    );

    if (response.statusCode == 200) {
      return Attendance.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Gagal membuat attendance: ${response.body}');
    }
  }

  // 🔹 Read Attendance (HR/CO bisa lihat semua, karyawan hanya miliknya)
  Future<List<Attendance>> fetchAttendances({String? employeeId, String? role}) async {
    String filter = "";

    if (role == "Employee") {
      filter = '?filters=[["employee","=","$employeeId"]]';
    }
    // HR/CO => otomatis dapat semua

    final url = Uri.parse('$baseUrl/api/resource/Attendance$filter');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((e) => Attendance.fromJson(e)).toList();
    } else {
      throw Exception('Gagal fetch attendance: ${response.body}');
    }
  }

  // 🔹 Approval (HR atau CO yang bisa ubah status)
  Future<Attendance?> approveAttendance(String name, String status, String role) async {
    if (!(role == "HR" || role == "CO")) {
      throw Exception("Unauthorized: hanya HR/CO yang bisa approve");
    }

    final url = Uri.parse('$baseUrl/api/resource/Attendance/$name');
    final response = await http.put(
      url,
      headers: _headers,
      body: jsonEncode({"status": status}),
    );

    if (response.statusCode == 200) {
      return Attendance.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Gagal update status: ${response.body}');
    }
  }

  // 🔹 Summary (buat dashboard HR/CO)
  Future<AttendanceSummary> fetchSummary({String? month, String? year}) async {
    final url = Uri.parse('$baseUrl/api/method/attendance.get_summary?month=$month&year=$year');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return AttendanceSummary.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal fetch summary: ${response.body}');
    }
  }
}
