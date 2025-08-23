import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee/employee.dart';

class EmployeeService {
  final String baseUrl = "https://your-frappe-api.com/api/method";

  /// HR → Ambil semua karyawan
  Future<List<Employee>> fetchAllEmployees() async {
    final response = await http.get(Uri.parse("$baseUrl/employee.get_all"));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      return jsonData.map((e) => Employee.fromJson(e)).toList();
    } else {
      throw Exception("Gagal load semua karyawan");
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
