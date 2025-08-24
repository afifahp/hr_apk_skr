import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/attendance/attendance_summary.dart';

class AttendanceChart extends StatelessWidget {
  final AttendanceSummary summary;
  const AttendanceChart({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final data = [
      _ChartData("Hadir", summary.totalHadir, Colors.green),
      _ChartData("Izin", summary.totalIzin, Colors.orange),
      _ChartData("Cuti", summary.totalCuti, Colors.blue),
      _ChartData("Alpha", summary.totalAlpha, Colors.red),
    ];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ringkasan Absensi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxY(data),
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < data.length) {
                            return Text(data[index].label);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: data
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.value.toDouble(),
                              color: entry.value.color,
                              width: 18,
                              borderRadius: BorderRadius.circular(4),
                            )
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxY(List<_ChartData> data) {
    final maxVal = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    return (maxVal + 5).toDouble();
  }
}

class _ChartData {
  final String label;
  final int value;
  final Color color;

  _ChartData(this.label, this.value, this.color);
}
