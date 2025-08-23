import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/salary/salary_history.dart';
import '../../models/salary/salary_slip.dart';

class SalaryService {
  static const String baseUrl = "https://your-frappe-api.com/api/method/salary";

  /// Ambil daftar periode gaji (misalnya per bulan)
  static Future<List<SalaryHistory>> getSalaryPeriods() async {
    final response = await http.get(Uri.parse("$baseUrl/periods"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => SalaryHistory.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat periode gaji");
    }
  }

  /// Ambil daftar slip gaji untuk periode tertentu
  static Future<List<SalarySlip>> getSalarySlips(String periodId) async {
    final response = await http.get(Uri.parse("$baseUrl/slips?period=$periodId"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => SalarySlip.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat slip gaji");
    }
  }

  /// Ambil detail slip gaji (misalnya link PDF)
  static Future<SalarySlip> getSalarySlipDetail(String slipId) async {
    final response = await http.get(Uri.parse("$baseUrl/slip/$slipId"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SalarySlip.fromJson(data);
    } else {
      throw Exception("Gagal memuat detail slip gaji");
    }
  }
}
