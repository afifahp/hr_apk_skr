import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/leave/leave_request.dart';

class LeaveService {
  final String baseUrl = "https://your-frappe-api.com/api/method";

  /// Ambil semua leave request sesuai role
  /// - HR  : semua karyawan
  /// - CO  : hanya divisinya
  /// - EMP : hanya dirinya sendiri
  Future<List<LeaveRequest>> fetchLeaveRequests(String role, String employeeId,
      {String? divisionId}) async {
    final url = Uri.parse("$baseUrl/leave/list");

    final response = await http.post(url, body: {
      "role": role,
      "employee_id": employeeId,
      "division_id": divisionId ?? "",
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => LeaveRequest.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data cuti");
    }
  }

  /// Karyawan buat pengajuan cuti
  Future<bool> createLeaveRequest(LeaveRequest request) async {
    final url = Uri.parse("$baseUrl/leave/create");

    final response = await http.post(url, body: request.toJson());

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// Chief update status pengajuan (approve/decline)
  Future<bool> updateLeaveStatus(int requestId, String status,
      {required String approver}) async {
    final url = Uri.parse("$baseUrl/leave/update");

    final response = await http.post(url, body: {
      "id": requestId.toString(),
      "status": status,
      "approver": approver,
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// Ambil detail leave request by ID
  Future<LeaveRequest> fetchLeaveDetail(int id) async {
    final url = Uri.parse("$baseUrl/leave/detail/$id");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LeaveRequest.fromJson(data);
    } else {
      throw Exception("Gagal mengambil detail cuti");
    }
  }
}
