import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/salary/salary_history.dart';
import '../../models/salary/salary_slip.dart';

class SalaryService {
  static const baseUrl = "https://localhost:8000/api/method";

  /// Ambil daftar periode slip gaji (riwayat)
  static Future<List<SalaryHistory>> getSalaryHistory() async {
    final response = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/method/hrpay.api.salary.get_periods"),
      headers: {
      "Content-Type": "application/json",
      "Authorization": "token 16eca678b8f5b49:ce3964e271151c3", // kalau pakai API key/secret
    // atau
    // "Cookie": "sid=your_session_id",  // kalau pakai login session
  },
    );
print(response.statusCode);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

     // Ambil data di dalam message.data
      final List data = body["message"]["data"];
      // print("Full response: $data");
      return data.map((e) => SalaryHistory.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat daftar periode gaji");
    }
  }

  /// Ambil slip gaji berdasarkan role
  static Future<List<SalarySlip>> getSalarySlips({
    required String periodId,
    String? employee,
    String? divisionId,
  }) async {
    final uri = Uri.parse("$baseUrl/hrpay.api.sallary.get_salary").replace(queryParameters: {
      // "name": name,
      if (employee != null) "employee": employee,
      if (divisionId != null) "division_id": divisionId,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => SalarySlip.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat slip gaji");
    }
  }
}
