import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/models/appointment_model.dart';
import 'package:prime_health_doctors/models/calling_model.dart';
import 'package:prime_health_doctors/models/user_model.dart';
import 'package:prime_health_doctors/service/calling_service.dart';
import 'package:prime_health_doctors/utils/config/session.dart';
import 'package:prime_health_doctors/utils/storage.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/dashboard/home/appointments/ui/calling_view.dart';

class AppointmentDetails extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetails({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            elevation: 0,
            toolbarHeight: 80,
            backgroundColor: AppTheme.backgroundWhite,
            pinned: true,
            floating: true,
            title: Text(
              'Appointment Details',
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            leading: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.backgroundLight,
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary, size: 24),
              onPressed: () => Get.back(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildPatientCard(),
                  const SizedBox(height: 20),
                  _buildAppointmentDetailsCard(),
                  const SizedBox(height: 20),
                  _buildMedicalInfoCard(),
                  const SizedBox(height: 20),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                _buildPatientAvatar(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName,
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                      ),
                      _buildStatusBadge(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.backgroundLight, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildContactInfo(Icons.phone_rounded, 'Phone', appointment.patientPhone),
                  const SizedBox(height: 12),
                  _buildContactInfo(Icons.email_rounded, 'Email', appointment.patientEmail),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientAvatar() {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: appointment.patientAvatar.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(appointment.patientAvatar, fit: BoxFit.cover),
                )
              : Center(
                  child: Text(
                    appointment.patientInitials,
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
                  ),
                ),
        ),
        if (appointment.isUrgent)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: AppTheme.emergencyRed, shape: BoxShape.circle),
              child: Icon(Icons.priority_high_rounded, size: 10, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final statusColor = _getStatusColor(appointment.status);
    final statusIcon = _getStatusIcon(appointment.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14, color: statusColor),
          const SizedBox(width: 6),
          Text(
            appointment.status.capitalizeFirst!,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String label, String value, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 16, color: AppTheme.primaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              if (onTap != null) Icon(Icons.chevron_right_rounded, color: AppTheme.textLight, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment Details',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            _buildDetailGrid(),
            const SizedBox(height: 16),
            if (appointment.notes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    'Additional Notes',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(appointment.notes, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary, height: 1.4)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildDetailItem(Icons.calendar_today_rounded, 'Date', appointment.displayDate)),
            Expanded(child: _buildDetailItem(Icons.access_time_rounded, 'Time', appointment.displayTime)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildDetailItem(Icons.medical_services_rounded, 'Service', appointment.service)),
            Expanded(child: _buildDetailItem(Icons.category_rounded, 'Service Type', appointment.serviceType)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildDetailItem(Icons.timer_rounded, 'Duration', appointment.duration)),
            Expanded(child: _buildDetailItem(Icons.attach_money_rounded, 'Consultation Fee', appointment.consultationFeeDisplay)),
          ],
        ),
        const SizedBox(height: 16),
        _buildDetailItem(Icons.payment_rounded, 'Payment Status', appointment.paymentStatus.capitalizeFirst!, valueColor: _getPaymentStatusColor(appointment.paymentStatus)),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppTheme.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 15, color: valueColor ?? AppTheme.textPrimary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildMedicalInfoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Information',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            _buildMedicalInfoItem('Age', appointment.patientAge),
            const SizedBox(height: 12),
            _buildMedicalInfoItem('Gender', appointment.patientGender),
            const SizedBox(height: 12),
            _buildMedicalInfoItem('Medical History', appointment.medicalHistory),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? 'Not specified' : value,
          style: GoogleFonts.inter(fontSize: 15, color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => onCallAction(context, CallType.voice),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Icon(Icons.phone_rounded, size: 18, color: Colors.white),
                    label: Text(
                      'Voice Call',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => onCallAction(context, CallType.video),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Icon(Icons.videocam_rounded, size: 18, color: Colors.white),
                    label: Text(
                      'Video Call',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (appointment.status.toLowerCase() == 'pending')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _confirmAppointment(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Confirm Appointment',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _cancelAppointment(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: AppTheme.emergencyRed),
                      ),
                      child: Text(
                        'Cancel Appointment',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.emergencyRed),
                      ),
                    ),
                  ),
                ],
              ),

            if (appointment.status.toLowerCase() == 'confirmed' && appointment.isToday)
              ElevatedButton(
                onPressed: () => _startConsultation(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: Text(
                  'Start Consultation',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            if (appointment.status.toLowerCase() == 'completed')
              OutlinedButton(
                onPressed: () => _viewMedicalRecords(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: AppTheme.primaryBlue),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: Text(
                  'View Medical Records',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
                ),
              ),
          ],
        ),
      ),
    );
  }

  onCallAction(BuildContext context, CallType callType) async {
    if (appointment.fcmToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Token is missing...!')));
      return;
    }
    final userData = await read(AppSession.userData);
    if (userData != null) {
      UserModel userModel = UserModel(
        id: "1",
        name: userData["name"] ?? 'Dr. John Smith',
        email: userData["email"] ?? 'john.smith@example.com',
        mobile: userData["mobile"] ?? '+91 98765 43210',
        password: userData["password"] ?? '********',
        specialty: userData["specialty"] ?? 'Orthopedic Physiotherapy',
        experienceYears: userData["experienceYears"] ?? 5,
        clinicName: userData["clinic"] ?? "PrimeHealth Clinic",
        clinicAddress: userData["clinicAddress"] ?? '123, Medical Street, City, State, 395009',
        referralCode: userData["referralCode"] ?? 'ABC',
        ownReferralCode: userData["ownReferralCode"] ?? 'AAA',
        registrationDate: userData["registrationDate"] ?? DateTime.now().toIso8601String(),
        fcmToken: userData["fcmToken"] ?? '',
      );
      String channelName = "${userModel.id}_${appointment.id}_${DateTime.now().millisecondsSinceEpoch}";
      CallData callData = CallData(senderId: userModel.id, senderName: userModel.name, senderFCMToken: userModel.fcmToken, callType: callType, status: CallStatus.calling, channelName: channelName);
      CallingService().makeCall(appointment.fcmToken, callData);
      if (context.mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CallingView(channelName: channelName, callType: callType, receiver: appointment, sender: userModel);
            },
          ),
        );
      }
    }
  }

  void _confirmAppointment() {
    Get.snackbar(
      'Appointment Confirmed',
      'Appointment with ${appointment.patientName} has been confirmed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.accentGreen,
      colorText: Colors.white,
      borderRadius: 12,
    );
  }

  void _cancelAppointment() {
    Get.snackbar(
      'Appointment Cancelled',
      'Appointment with ${appointment.patientName} has been cancelled',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.emergencyRed,
      colorText: Colors.white,
      borderRadius: 12,
    );
  }

  void _startConsultation() {
    Get.snackbar(
      'Consultation Started',
      'Starting consultation with ${appointment.patientName}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.primaryBlue,
      colorText: Colors.white,
      borderRadius: 12,
    );
  }

  void _viewMedicalRecords() {
    Get.snackbar(
      'Medical Records',
      'Opening medical records for ${appointment.patientName}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.primaryBlue,
      colorText: Colors.white,
      borderRadius: 12,
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppTheme.accentGreen;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return AppTheme.emergencyRed;
      case 'completed':
        return AppTheme.primaryBlue;
      default:
        return AppTheme.primaryBlue;
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return AppTheme.accentGreen;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return AppTheme.emergencyRed;
      default:
        return AppTheme.textPrimary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle_outline_rounded;
      case 'pending':
        return Icons.pending_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'completed':
        return Icons.verified_rounded;
      default:
        return Icons.calendar_today_rounded;
    }
  }
}
