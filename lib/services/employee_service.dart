import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee/employee.dart';

class EmployeeService {
  static const String baseUrl = "http://127.0.0.1:8000/api/method/";
  static const Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "token 16eca678b8f5b49:f71aca06b17f10a",
  };

  /// HR → Ambil semua karyawan
  Future<List<Employee>> fetchAllEmployees() async {
    final response = await http.get(Uri.parse("http://localhost:8000/api/method/hrpay.api.employee.get_all_employees"), headers: headers);
print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    if (response.statusCode == 200) {
  final decoded = jsonDecode(response.body);
  // Frappe biasanya bungkus data di "message" → "data"
  final rawData = decoded['message']?['data'] ?? [];

  final List<dynamic> dataList = rawData is List ? rawData : [rawData];

  return dataList.map((e) => Employee.fromJson(e)).toList();
} else {
  throw Exception("Gagal load semua karyawan: ${response.statusCode}");
}

  }

  /// CO → Ambil karyawan dalam divisi tertentu
  Future<List<Employee>> fetchEmployeesByDivision(String division) async {
    final response = await http.get(
      Uri.parse("$baseUrl/employee.get_by_division?division=$division"),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      return jsonData.map((e) => Employee.fromJson(e)).toList();
    } else {
      throw Exception("Gagal load karyawan divisi $division");
    }
  }

  /// Employee → Ambil data dirinya sendiri
  Future<Employee> fetchSelfEmployee(String userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/employee.get_self?user=$userId"),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Employee.fromJson(jsonData);
    } else {
      throw Exception("Gagal load data karyawan");
    }
  }
}
