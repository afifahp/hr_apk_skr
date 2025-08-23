import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard/dashboard.dart';

class ApiService {
  static const String baseUrl = "https://your-frappe-api.com/api/method";

  static Future<DashboardData> fetchDashboardData(String role) async {
    final response = await http.get(
      Uri.parse("$baseUrl/dashboard.get_data"),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return DashboardData.fromJson(json, role);
    } else {
      throw Exception("Failed to load dashboard data");
    }
  }

  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      body: {"usr": email, "pwd": password},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Login failed");
    }
  }
}
