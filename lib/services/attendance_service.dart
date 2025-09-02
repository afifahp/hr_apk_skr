

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/attendance/attendance.dart';




class AttendanceService {
  static const String baseUrl =
      "http://127.0.0.1:8000/api/method/hrpay.api.attendance.get_all_attendance";

  static const Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization":
        "token 16eca678b8f5b49:f71aca06b17f10a", // ganti sesuai API kamu
  };



  static Future<List<Attendance>> getAllAttendance() async {
    // final response = await http.get(Uri.parse('$baseUrl/hrpay.api.attendance.get_all_attendance'));
    final response = await http.get(Uri.parse(baseUrl), headers: headers);

print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // pastikan 'data' itu list
      if (data is List) {
  // jarang, kalau API langsung array []
  return data.map((e) => Attendance.fromJson(e)).toList();
} else if (data is Map && data['message'] != null && data['message']['data'] is List) {
  // sesuai struktur API kamu
  return (data['message']['data'] as List)
      .map((e) => Attendance.fromJson(e))
      .toList();
} else {
  throw Exception("Format response tidak sesuai: $data");
}
    } else {
      throw Exception("Gagal load attendance");
    }
  }
}