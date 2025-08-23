import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/attendance/wfa_request.dart';

class WfaService {
  final String baseUrl = "https://your-frappe-api.com/api/method";

  /// Submit request WFA/H (status awal = pending)
  Future<WfaRequest> submitRequest(WfaRequest request) async {
    final response = await http.post(
      Uri.parse("$baseUrl/wfa.submit"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return WfaRequest.fromJson(jsonData);
    } else {
      throw Exception("Gagal submit WFA request");
    }
  }

  /// Ambil semua request WFA/H milik karyawan (history)
  Future<List<WfaRequest>> fetchRequestsByEmployee(String employeeId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/wfa.get_by_employee?employee_id=$employeeId"),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      return jsonData.map((e) => WfaRequest.fromJson(e)).toList();
    } else {
      throw Exception("Gagal load request WFA karyawan");
    }
  }

  /// Ambil semua request pending untuk HR/CO (approval)
  Future<List<WfaRequest>> fetchPendingRequests() async {
    final response = await http.get(
      Uri.parse("$baseUrl/wfa.get_pending"),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      return jsonData.map((e) => WfaRequest.fromJson(e)).toList();
    } else {
      throw Exception("Gagal load pending requests");
    }
  }

  /// Approve / Reject request (HR/CO)
  Future<void> updateRequestStatus(String requestId, String newStatus) async {
    final response = await http.post(
      Uri.parse("$baseUrl/wfa.update_status"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": requestId,
        "status": newStatus, // approved / rejected
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal update status request");
    }
  }
}
