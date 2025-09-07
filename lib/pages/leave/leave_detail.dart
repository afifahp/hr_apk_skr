import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/leave/leave_request.dart';

class LeaveDetail extends StatelessWidget {
  final LeaveRequest leaveRequest;

  const LeaveDetail({Key? key, required this.leaveRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengajuan Cuti/Izin'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildSectionHeader('Pengajuan Cuti/Izin'),
            const SizedBox(height: 16),

            // Jenis Izin/Cuti
            _buildInfoCard(
              title: 'Jenis Izin/Cuti',
              value: leaveRequest.leaveType,
            ),
            const SizedBox(height: 16),

            // Tanggal dan Alasan Section
            _buildSectionHeader('Tanggal dan Alasan'),
            const SizedBox(height: 16),

            // Tanggal
            _buildDateInfo(),
            const SizedBox(height: 16),

            // Alasan
            _buildInfoCard(
              title: 'Alasan',
              value: leaveRequest.descLeave,
            ),
            const SizedBox(height: 16),

            // Approval Section
            _buildSectionHeader('Approval'),
            const SizedBox(height: 16),

            // Pemberi Izin
            _buildInfoCard(
              title: 'Pemberi Izin',
              value: leaveRequest.leaveApprover.isNotEmpty
                  ? leaveRequest.leaveApprover
                  : 'Belum ditentukan',
            ),
            const SizedBox(height: 16),

            // Lampiran
            _buildAttachmentInfo(),
            const SizedBox(height: 16),

            // Status
            _buildStatusInfo(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String value}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo() {
    final dateFormat = DateFormat('dd MMMM yyyy');
    final isSameDay =
        leaveRequest.fromDate.isAtSameMomentAs(leaveRequest.toDate);

    String dateText;
    if (isSameDay) {
      if (leaveRequest.halfDay == 1) {
        dateText =
            '${dateFormat.format(leaveRequest.fromDate)} (Setengah Hari)';
      } else {
        dateText = dateFormat.format(leaveRequest.fromDate);
      }
    } else {
      dateText =
          '${dateFormat.format(leaveRequest.fromDate)} - ${dateFormat.format(leaveRequest.toDate)}';
    }

    return _buildInfoCard(
      title: isSameDay ? 'Tanggal' : 'Dari - Sampai',
      value: dateText,
    );
  }

  Widget _buildAttachmentInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lampiran',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            leaveRequest.attachment != null &&
                    leaveRequest.attachment!.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      // TODO: buka file lampiran
                    },
                    child: const Text(
                      'Lihat Lampiran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : const Text(
                    'Tidak ada lampiran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusInfo() {
    Color statusColor;
    switch (leaveRequest.status.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      case 'pending':
      case 'open':
      default:
        statusColor = Colors.orange;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                leaveRequest.status,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
