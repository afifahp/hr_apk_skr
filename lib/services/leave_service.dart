import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/leave/leave_request.dart';

class LeaveService {
  /// Base URL backend Frappe/ERPNext
  static const String baseUrl = "http://127.0.0.1:8000/api/resource";

  /// Ambil header auth (token / bearer)
  Future<Map<String, String>> _getHeaders({bool isMultipart = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    // kalau token formatnya "api_key:api_secret"
    final auth = token.contains(":") ? "token $token" : "Bearer $token";

    return {
      if (!isMultipart) "Content-Type": "application/json",
      "Authorization": auth,
    };
  }

  /// Helper decode response JSON (support data/message)
  dynamic _extractData(http.Response res) {
    final decoded = jsonDecode(res.body);
    return decoded['data'] ?? decoded['message'] ?? decoded;
  }

  /// Ambil semua leave request
  Future<List<LeaveRequest>> fetchLeaveRequests(
    String role,
    String userId, {
    String? divisionId,
  }) async {
    final headers = await _getHeaders();
    final url = Uri.parse("$baseUrl/Leave Request?fields=[\"*\"]");

    final res = await http.get(url, headers: headers);
    if (res.statusCode != 200) {
      throw Exception("Gagal ambil data cuti: ${res.statusCode} ${res.body}");
    }

    final raw = _extractData(res);
    if (raw == null) return [];
    final list = raw is List
        ? raw
        : raw is Map && raw["data"] is List
            ? raw["data"]
            : [raw];
    return list.map<LeaveRequest>((e) => LeaveRequest.fromJson(e)).toList();
  }

  /// Ambil leave request berdasarkan user (auth)
  Future<List<LeaveRequest>> fetchLeaveRequestsAuth(
    String role,
    String userId, {
    String? divisionId,
  }) async {
    final headers = await _getHeaders();
    final url = Uri.parse(
      "$baseUrl/Leave Request?filters=" +
          Uri.encodeComponent(jsonEncode({
            "id": userId, // pakai id, bukan employee_id
          })) +
          "&fields=[\"*\"]",
    );

    final res = await http.get(url, headers: headers);
    if (res.statusCode != 200) {
      throw Exception(
          "Gagal ambil data cuti (auth): ${res.statusCode} ${res.body}");
    }

    final raw = _extractData(res);
    if (raw == null) return [];
    final list = raw is List
        ? raw
        : raw is Map && raw["data"] is List
            ? raw["data"]
            : [raw];
    return list.map<LeaveRequest>((e) => LeaveRequest.fromJson(e)).toList();
  }

  /// Buat leave request baru
  Future<bool> createLeaveRequest(
    LeaveRequest request, {
    String? filePath,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    final url = Uri.parse("$baseUrl/Leave Request");
    final headers = await _getHeaders();

    final fromDate = request.fromDate.toIso8601String().substring(0, 10);
    final toDate = request.toDate.toIso8601String().substring(0, 10);

    final body = {
      "id": request.id, // pakai id
      "employee_name": request.employeeName,
      "job_position": request.jobPosition,
      "department": request.department,
      "leave_type": request.leaveType,
      "from_date": fromDate,
      "to_date": toDate,
      "half_day": request.halfDay,
      "leave_approver": request.leaveApprover,
      "status": request.status,
      "desc_leave": request.descLeave,
    };

    final res = await http.post(url, headers: headers, body: jsonEncode(body));
    print("Create leave → ${res.statusCode} ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("Gagal create cuti: ${res.statusCode} ${res.body}");
    }
    return true;
  }

  /// Update status cuti (approve / reject)
  Future<bool> updateLeaveStatus(
    String requestId,
    String status, {
    required String approver,
  }) async {
    final headers = await _getHeaders();
    final url = Uri.parse("$baseUrl/Leave Request/$requestId");

    final body = jsonEncode({
      "status": status,
      "leave_approver": approver,
    });

    final res = await http.put(url, headers: headers, body: body);
    print("Update leave → ${res.statusCode} ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("Gagal update cuti: ${res.statusCode} ${res.body}");
    }
    return true;
  }

  /// Ambil detail cuti berdasarkan ID
  Future<LeaveRequest> fetchLeaveDetail(String id) async {
    final headers = await _getHeaders();
    final url = Uri.parse("$baseUrl/Leave Request/$id");

    final res = await http.get(url, headers: headers);
    if (res.statusCode != 200) {
      throw Exception(
          "Gagal mengambil detail cuti: ${res.statusCode} ${res.body}");
    }
    final data = _extractData(res);
    return LeaveRequest.fromJson(data);
  }
}
