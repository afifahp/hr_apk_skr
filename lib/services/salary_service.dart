import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/salary/salary_history.dart';
import '../../models/salary/salary_slip.dart';

class SalaryService {
  static const baseUrl = "https://your-frappe-api.com/api/method";

  /// 🔹 Ambil daftar periode slip gaji (riwayat)
  static Future<List<SalaryHistory>> getSalaryHistory() async {
    final response = await http.get(
      Uri.parse("$baseUrl/salary/get_periods"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => SalaryHistory.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat daftar periode gaji");
    }
  }

  /// 🔹 Ambil slip gaji untuk periode tertentu
  static Future<List<SalarySlip>> getSalarySlips(String periodId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/salary/slips?period=$periodId"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => SalarySlip.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat slip gaji");
    }
  }
}
