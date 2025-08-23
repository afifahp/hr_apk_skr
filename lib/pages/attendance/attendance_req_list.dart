import 'package:flutter/material.dart';
import 'attendance_approval.dart';

class AttendanceRequestListPage extends StatefulWidget {
  const AttendanceRequestListPage({super.key});

  @override
  State<AttendanceRequestListPage> createState() =>
      _AttendanceRequestListPageState();
}

class _AttendanceRequestListPageState
    extends State<AttendanceRequestListPage> {
  String role = "KARYAWAN"; // default role
  String currentUserId = "EMP001";
  String currentDivision = "IT";

  // 🔹 Dummy data khusus WFH/A Request
  List<Map<String, dynamic>> requests = [
    {
      "id": "REQ-001",
      "userId": "EMP001",
      "name": "Karyawan 1",
      "dept": "QA - IT",
      "division": "IT",
      "chiefOfficerId": "CO123",
      "reason": "WFH karena urusan keluarga",
      "approver": "CTO",
      "date": "2025-01-17",
      "status": "PENDING",
    },
    {
      "id": "REQ-002",
      "userId": "EMP002",
      "name": "Karyawan 2",
      "dept": "Marketing",
      "division": "Marketing",
      "chiefOfficerId": "CO999",
      "reason": "Work from anywhere",
      "approver": "CMO",
      "date": "2025-01-18",
      "status": "APPROVED",
    },
    {
      "id": "REQ-003",
      "userId": "EMP003",
      "name": "Karyawan 3",
      "dept": "QA - IT",
      "division": "IT",
      "chiefOfficerId": "CO123",
      "reason": "WFH karena sakit ringan",
      "approver": "CTO",
      "date": "2025-01-19",
      "status": "REJECTED",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 🔹 filter sesuai role
    List<Map<String, dynamic>> filteredRequests = requests.where((req) {
      if (role == "KARYAWAN") {
        return req["userId"] == currentUserId;
      } else if (role == "CO") {
        return req["chiefOfficerId"] == "CO123" &&
            req["division"] == currentDivision;
      } else {
        return true; // HR
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pengajuan WFH/A"),
        actions: [
          // 🔹 Role switcher (buat testing aja)
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                role = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "KARYAWAN", child: Text("Karyawan")),
              const PopupMenuItem(value: "CO", child: Text("Chief Officer")),
              const PopupMenuItem(value: "HR", child: Text("HR")),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.person),
                  Text(" $role"),
                ],
              ),
            ),
          ),
        ],
      ),
      body: filteredRequests.isEmpty
          ? const Center(child: Text("Tidak ada request WFH/A"))
          : ListView.builder(
              itemCount: filteredRequests.length,
              itemBuilder: (context, index) {
                final req = filteredRequests[index];
                final isPending = req["status"] == "PENDING";

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text("${req["name"]} (${req["dept"]})"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tanggal: ${req["date"]}"),
                        Text("Alasan: ${req["reason"]}"),
                        Text("Status: ${req["status"]}"),
                      ],
                    ),
                    trailing: _buildTrailing(context, req, isPending),
                    onTap: () {
                      if (role == "CO" || role == "HR") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AttendanceApprovalPage(
                              id: req["id"],
                              name: req["name"],
                              dept: req["dept"],
                              reason: req["reason"],
                              approver: req["approver"],
                              status: req["status"],
                              isReadOnly: role == "HR",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }

  Widget _buildTrailing(
      BuildContext context, Map<String, dynamic> req, bool isPending) {
    if (role == "KARYAWAN" && isPending) {
      return IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          setState(() {
            requests.removeWhere((r) => r["id"] == req["id"]);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Request berhasil dihapus")),
          );
        },
      );
    }
    return null;
  }
}
