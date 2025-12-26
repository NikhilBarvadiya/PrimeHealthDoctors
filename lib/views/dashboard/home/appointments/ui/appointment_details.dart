import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/utils/decoration.dart';
import 'package:prime_health_doctors/utils/toaster.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prime_health_doctors/models/appointment_model.dart';
import 'package:prime_health_doctors/models/calling_model.dart';
import 'package:prime_health_doctors/models/user_model.dart';
import 'package:prime_health_doctors/service/calling_service.dart';
import 'package:prime_health_doctors/utils/config/session.dart';
import 'package:prime_health_doctors/utils/storage.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/auth/auth_service.dart';
import 'package:prime_health_doctors/views/dashboard/home/appointments/ui/calling_view.dart';

class AppointmentDetails extends StatefulWidget {
  final AppointmentModel appointment;

  const AppointmentDetails({super.key, required this.appointment});

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            elevation: 0,
            toolbarHeight: 80,
            backgroundColor: Colors.white,
            pinned: true,
            floating: true,
            title: Column(
              spacing: 2.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointment',
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                Text(
                  'Details',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: AppTheme.textPrimary),
                ),
              ],
            ),
            leading: IconButton(
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.white,
                side: BorderSide(color: decoration.colorScheme.primary.withOpacity(.1)),
              ),
              icon: Icon(Icons.arrow_back_rounded, color: decoration.colorScheme.primary, size: 24),
              onPressed: () => Get.close(1),
            ),
            actions: [
              IconButton(
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: decoration.colorScheme.primary.withOpacity(.1)),
                ),
                icon: Icon(Icons.phone_rounded, color: decoration.colorScheme.primary, size: 20),
                onPressed: () => onCallAction(context, CallType.voice),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: decoration.colorScheme.primary.withOpacity(.1)),
                ),
                icon: Icon(Icons.videocam_rounded, color: decoration.colorScheme.primary, size: 20),
                onPressed: () => onCallAction(context, CallType.video),
              ),
              const SizedBox(width: 10),
            ],
          ),
          SliverToBoxAdapter(child: isLoading ? _buildShimmerDetails() : _buildAppointmentDetails()),
        ],
      ),
    );
  }

  Widget _buildShimmerDetails() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildShimmerCard(height: 180),
          const SizedBox(height: 16),
          _buildShimmerCard(height: 220),
          const SizedBox(height: 16),
          _buildShimmerCard(height: 140),
          const SizedBox(height: 16),
          _buildShimmerCard(height: 100),
        ],
      ),
    );
  }

  Widget _buildShimmerCard({double height = 100}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        height: height,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildAppointmentDetails() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildPatientCard(),
          const SizedBox(height: 16),
          _buildAppointmentDetailsCard(),
          const SizedBox(height: 16),
          _buildMedicalInfoCard(),
          const SizedBox(height: 16),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildPatientCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _buildPatientAvatar(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.appointment.patientName,
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      _buildStatusBadge(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.backgroundLight, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  if (widget.appointment.patientPhone != null && widget.appointment.patientPhone!.isNotEmpty) _buildContactInfo(Icons.phone_rounded, 'Phone', widget.appointment.patientPhone!),
                  if (widget.appointment.patientPhone != null && widget.appointment.patientPhone!.isNotEmpty) const SizedBox(height: 8),
                  _buildContactInfo(Icons.email_rounded, 'Email', widget.appointment.patientEmail ?? 'Not provided'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Text(
          widget.appointment.patientInitials,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final statusColor = _getStatusColor(widget.appointment.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        widget.appointment.statusDisplay.toUpperCase(),
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
          child: Icon(icon, size: 14, color: AppTheme.primaryBlue),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment Details',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 12),
            _buildDetailGrid(),
            if (widget.appointment.notes != null && widget.appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppTheme.borderColor),
              const SizedBox(height: 12),
              Text(
                'Additional Notes',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(widget.appointment.notes!, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, height: 1.4)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailGrid() {
    return Column(
      children: [
        _buildDetailRow(
          icon1: Icons.calendar_today_rounded,
          label1: 'Date',
          value1: widget.appointment.displayDate,
          icon2: Icons.access_time_rounded,
          label2: 'Time',
          value2: widget.appointment.displayTime,
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          icon1: Icons.medical_services_rounded,
          label1: 'Service',
          value1: widget.appointment.serviceName ?? 'Consultation',
          icon2: Icons.timer_rounded,
          label2: 'Duration',
          value2: widget.appointment.duration ?? '30 mins',
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          icon1: Icons.attach_money_rounded,
          label1: 'Consultation Fee',
          value1: widget.appointment.consultationFeeDisplay,
          icon2: Icons.payment_rounded,
          label2: 'Payment Status',
          value2: widget.appointment.paymentStatus.capitalizeFirst ?? 'Pending',
          value2Color: _getPaymentStatusColor(widget.appointment.paymentStatus),
        ),
      ],
    );
  }

  Widget _buildDetailRow({required IconData icon1, required String label1, required String value1, required IconData icon2, required String label2, required String value2, Color? value2Color}) {
    return Row(
      children: [
        Expanded(child: _buildDetailItem(icon1, label1, value1)),
        const SizedBox(width: 12),
        Expanded(child: _buildDetailItem(icon2, label2, value2, valueColor: value2Color)),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 13, color: valueColor ?? AppTheme.textPrimary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Information',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 12),
            _buildMedicalInfoItem('Age', widget.appointment.patientAge ?? 'Not specified'),
            const SizedBox(height: 8),
            _buildMedicalInfoItem('Gender', widget.appointment.patientGender ?? 'Not specified'),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalInfoItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppTheme.backgroundLight, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final status = widget.appointment.status.toLowerCase();

    if (status != 'scheduled' && status != 'confirmed') {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (status == 'scheduled')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _confirmAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Confirm Booking', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancelAppointment,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.emergencyRed,
                        side: const BorderSide(color: AppTheme.emergencyRed),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            if (status == 'confirmed')
              ElevatedButton(
                onPressed: _completeAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: Text('Complete Consultation', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
          ],
        ),
      ),
    );
  }

  onCallAction(BuildContext context, CallType callType) async {
    if (widget.appointment.patientFcm.toString().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Token is missing...!')));
      return;
    }
    final userData = await read(AppSession.userData);
    if (userData != null) {
      UserModel userModel = UserModel(
        id: userData["_id"] ?? "",
        fcm: userData["fcm"] ?? "",
        name: userData["name"] ?? 'Dr. John Smith',
        email: userData["email"] ?? 'john.smith@example.com',
        mobile: userData["mobile"] ?? '+91 98765 43210',
        specialty: userData["specialty"] ?? 'Orthopedic Physiotherapy',
      );
      String channelName = "${userModel.id}_${widget.appointment.id}_${DateTime.now().millisecondsSinceEpoch}";
      CallData callData = CallData(senderId: userModel.id, senderName: userModel.name, senderFCMToken: userModel.fcm, callType: callType, status: CallStatus.calling, channelName: channelName);
      CallingService().makeCall(widget.appointment, callData);
      if (context.mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CallingView(channelName: channelName, callType: callType, receiver: widget.appointment, sender: userModel);
            },
          ),
        );
      }
    }
  }

  void _confirmAppointment() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.successGreen.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.check_circle_rounded, color: AppTheme.successGreen, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Confirm Appointment?',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to confirm this appointment with ${widget.appointment.patientName}?',
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.close(1),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textSecondary,
                        side: BorderSide(color: AppTheme.borderColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Cancel', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.close(1);
                        _updateAppointmentStatus('confirmed', 'Appointment confirmed successfully');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Confirm', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _cancelAppointment() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.emergencyRed.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.cancel_rounded, color: AppTheme.emergencyRed, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Cancel Appointment?',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to cancel this appointment with ${widget.appointment.patientName}? This action cannot be undone.',
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.close(1),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textSecondary,
                        side: BorderSide(color: AppTheme.borderColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Keep Appointment', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.close(1);
                        _updateAppointmentStatus('cancelled', 'Appointment cancelled successfully');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.emergencyRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Cancel Appointment', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _completeAppointment() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.verified_rounded, color: AppTheme.primaryBlue, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Complete Consultation?',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Mark this consultation with ${widget.appointment.patientName} as completed? This will close the appointment.',
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.close(1),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textSecondary,
                        side: BorderSide(color: AppTheme.borderColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Not Yet', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.close(1);
                        _updateAppointmentStatus('completed', 'Consultation completed successfully');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Complete', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _updateAppointmentStatus(String status, String successMessage) async {
    try {
      setState(() => isLoading = true);
      final authService = Get.find<AuthService>();
      final response = await authService.updateBookingStatus({'bookingId': widget.appointment.id, 'status': status});
      if (response != null) {
        widget.appointment.status = status;
        toaster.success(successMessage);
      }
    } catch (e) {
      toaster.error(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppTheme.successGreen;
      case 'scheduled':
        return AppTheme.primaryBlue;
      case 'cancelled':
        return AppTheme.emergencyRed;
      case 'completed':
        return Colors.purple;
      case 'rescheduled':
        return Colors.amber;
      default:
        return AppTheme.primaryBlue;
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return AppTheme.successGreen;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return AppTheme.emergencyRed;
      default:
        return AppTheme.textPrimary;
    }
  }
}
