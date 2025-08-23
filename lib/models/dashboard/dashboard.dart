import '../attendance/attendance_overview.dart';
import '../leave/holiday.dart';
import '../leave/leave_balance.dart';

/// Model utama untuk data dashboard
class DashboardData {
  /// Summary kehadiran seluruh karyawan (hanya untuk HR & CO)
  final AttendanceOverview? attendanceOverview;

  /// Daftar hari libur mendatang (monthly/yearly)
  final List<Holiday> holidays;

  /// Sisa cuti karyawan
  final LeaveBalance leaveBalance;

  DashboardData({
    this.attendanceOverview,
    required this.holidays,
    required this.leaveBalance,
  });

  /// Factory untuk konversi dari JSON
  factory DashboardData.fromJson(Map<String, dynamic> json, String role) {
    return DashboardData(
      attendanceOverview: (role == "HR" || role == "CO")
          ? AttendanceOverview.fromJson(json["attendance_summary"])
          : null,
      holidays: (json["holidays"] as List<dynamic>)
          .map((h) => Holiday.fromJson(h))
          .toList(),
      leaveBalance: LeaveBalance.fromJson(json["leave_balance"]),
    );
  }
}
