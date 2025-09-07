import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dashboard/dashboard.dart';
import '../models/auth/user.dart'; // <-- tambahin model user kamu

class ApiService {
  // ⚠️ Kalau di emulator Android, ganti jadi "http://10.0.2.2:8000"
  static const String baseUrl = "http://127.0.0.1:8000";

  /// 🔹 Login user & simpan session ID (sid) ke SharedPreferences
  static Future<User> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/method/hrpay.api.login.auth"),
        body: {"usr": email, "pwd": password},
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        // ambil cookie sid dari header
        final cookies = response.headers['set-cookie'] ?? "";
        final sid = _extractSid(cookies);

        if (sid != null) {
          await prefs.setString("sid", sid);
        }

        final res = jsonDecode(response.body);

        // ✅ backend kamu bungkus semua di "message"
        final msg = res["message"];

        if (msg != null && msg["success"] == true) {
          // Simpan api_key & api_secret juga kalau perlu
          await prefs.setString("api_key", msg["api_key"]);
          await prefs.setString("api_secret", msg["api_secret"]);

          // mapping ke model User
          return User.fromJson(msg["user"]);
        } else {
          throw Exception(msg?["message"] ?? "Login gagal");
        }
      } else {
        throw Exception("Login failed: ${response.body}");
      }
    } catch (e) {
      throw Exception("Login error: $e");
    }
  }

  /// 🔹 Ambil data dashboard (butuh sid dari login)
  static Future<DashboardData> fetchDashboardData(String role) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString("sid");

      final response = await http.get(
        Uri.parse("$baseUrl/dashboard.get_data"),
        headers: {
          if (sid != null) "Cookie": "sid=$sid",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return DashboardData.fromJson(json, role);
      } else {
        throw Exception("Failed to load dashboard data: ${response.body}");
      }
    } catch (e) {
      throw Exception("Dashboard fetch error: $e");
    }
  }

  /// 🔹 Helper untuk ambil sid dari cookie string
  static String? _extractSid(String cookies) {
    final parts = cookies.split(";");
    for (var p in parts) {
      if (p.trim().startsWith("sid=")) {
        return p.trim().substring(4);
      }
    }
    return null;
  }
}
