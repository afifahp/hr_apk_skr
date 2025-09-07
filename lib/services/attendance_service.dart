import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/attendance/attendance.dart';

class AttendanceService {
  
  static const String baseUrl = "http://127.0.0.1:8000/api/method/";
  
  static const Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "token b531f47fc2742a1:633f036f38ced2b", // sesuaikan token
  };

  // HR → Ambil semua attendance berdasarkan employee yang login
static Future<List<Attendance>> fetchAllAttendanceemployee() async {
  try {
    final response = await http.get(
      Uri.parse("http://localhost:8000/api/method/hrpay.api.attendance.get_all_attendance_employe"),
      headers: headers,
    );

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      
      // Print struktur response untuk debugging
      print("Decoded response: $decoded");

      // Penanganan response berdasarkan struktur yang mungkin
      if (decoded is Map) {
        if (decoded['message'] != null) {
          // Case 1: Response dengan key 'message'
          final messageData = decoded['message'];
          if (messageData is Map && messageData['data'] is List) {
            return (messageData['data'] as List)
                .map((e) => Attendance.fromJson(e))
                .toList();
          } else if (messageData is List) {
            // Case 2: Message langsung berisi list
            return messageData.map((e) => Attendance.fromJson(e)).toList();
          }
        } else if (decoded['data'] is List) {
          // Case 3: Response dengan key 'data' langsung
          return (decoded['data'] as List)
              .map((e) => Attendance.fromJson(e))
              .toList();
        }
      } else if (decoded is List) {
        // Case 4: Response langsung berupa list
        return decoded.map((e) => Attendance.fromJson(e)).toList();
      }

      throw Exception("Format response tidak sesuai: $decoded");
    } else if (response.statusCode == 401) {
      throw Exception("Authentication failed - Please login again");
    } else if (response.statusCode == 403) {
      throw Exception("Permission denied");
    } else {
      throw Exception("Gagal load attendance. Status: ${response.statusCode}");
    }
  } on http.ClientException catch (e) {
    throw Exception("Connection error: $e");
  } on FormatException catch (e) {
    throw Exception("Invalid JSON format: $e");
  } catch (e) {
    throw Exception("Unexpected error: $e");
  }
}
  /// HR → Ambil semua attendance
  static Future<List<Attendance>> fetchAllAttendance() async {
    final response = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/method/hrpay.api.attendance.get_all_attendance"),
      headers: headers,
    );

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded.map((e) => Attendance.fromJson(e)).toList();
      } else if (decoded is Map && decoded['message']?['data'] is List) {
        return (decoded['message']['data'] as List)
            .map((e) => Attendance.fromJson(e))
            .toList();
      } else {
        throw Exception("Format response tidak sesuai: $decoded");
      }
    } else {
      throw Exception("Gagal load semua attendance");
    }
  }

  /// CO → Ambil attendance berdasarkan department
  static Future<List<Attendance>> fetchAttendanceByDepartment(String department) async {
    final response = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/method/hrpay.api.attendance.get_attendance_by_department?department=$department"),
      headers: headers,
    );

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded.map((e) => Attendance.fromJson(e)).toList();
      } else if (decoded is Map && decoded['message']?['data'] is List) {
        return (decoded['message']['data'] as List)
            .map((e) => Attendance.fromJson(e))
            .toList();
      } else {
        throw Exception("Format response tidak sesuai: $decoded");
      }
    } else {
      throw Exception("Gagal load attendance department $department");
    }
  }

  /// Employee → Ambil attendance dirinya sendiri
  static Future<List<Attendance>> fetchSelfAttendance(String userId) async {
    final response = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/method/hrpay.api.attendance.get_self?user=$userId"),
      headers: headers,
    );

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded.map((e) => Attendance.fromJson(e)).toList();
      } else if (decoded is Map && decoded['message']?['data'] is List) {
        return (decoded['message']['data'] as List)
            .map((e) => Attendance.fromJson(e))
            .toList();
      } else {
        throw Exception("Format response tidak sesuai: $decoded");
      }
    } else {
      throw Exception("Gagal load attendance user $userId");
    }
  }
}
