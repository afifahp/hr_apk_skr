import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/employee/employee.dart';
import '../../models/employee/employee.dart';
// import '../services/employee_service.dart';
import '../../services/employee_service.dart';

class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = EmployeeService();

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Employee")),
      body: FutureBuilder<List<Employee>>(
        future: service.fetchAllEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final employees = snapshot.data ?? [];

          if (employees.isEmpty) {
            return const Center(child: Text("Tidak ada employee"));
          }

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final emp = employees[index];
              return ListTile(
                title: Text(emp.employeeName),
                subtitle: Text(emp.department ?? "Department tidak tersedia"),
                trailing: Text(emp.status ?? ""),
                onTap: () {
                  // Bisa navigasi ke detail page jika mau
                },
              );
            },
          );
        },
      ),
    );
  }
}
