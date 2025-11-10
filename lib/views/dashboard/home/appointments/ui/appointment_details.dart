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
            actions: [
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.backgroundLight,
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: Icon(Icons.phone_rounded, color: AppTheme.textPrimary, size: 24),
                onPressed: () => onCallAction(context, CallType.voice),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.backgroundLight,
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: Icon(Icons.videocam_rounded, color: AppTheme.textPrimary, size: 24),
                onPressed: () => onCallAction(context, CallType.video),
              ),
              SizedBox(width: 10),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  if (isLoading) _buildLoadingState(),
                  if (!isLoading)
                    Column(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.primaryBlue),
          const SizedBox(height: 16),
          Text('Loading booking details...', style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textSecondary)),
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
                        widget.appointment.patientName,
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 8),
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
                  if (widget.appointment.patientPhone != null && widget.appointment.patientPhone!.isNotEmpty) _buildContactInfo(Icons.phone_rounded, 'Phone', widget.appointment.patientPhone!),
                  if (widget.appointment.patientPhone != null && widget.appointment.patientPhone!.isNotEmpty) const SizedBox(height: 12),
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
      width: 60,
      height: 60,
      decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Text(
          widget.appointment.patientInitials,
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final statusColor = _getStatusColor(widget.appointment.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        widget.appointment.statusDisplay,
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Padding(
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
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
            if (widget.appointment.notes != null && widget.appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Additional Notes',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(widget.appointment.notes!, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary, height: 1.4)),
            ],
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
            Expanded(child: _buildDetailItem(Icons.calendar_today_rounded, 'Date', widget.appointment.displayDate)),
            Expanded(child: _buildDetailItem(Icons.access_time_rounded, 'Time', widget.appointment.displayTime)),
          ],
        ),
        const SizedBox(height: 12),
        _buildDetailItem(Icons.medical_services_rounded, 'Service', widget.appointment.serviceName ?? 'Consultation'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildDetailItem(Icons.timer_rounded, 'Duration', widget.appointment.duration ?? '30 mins')),
            Expanded(child: _buildDetailItem(Icons.attach_money_rounded, 'Consultation Fee', widget.appointment.consultationFeeDisplay)),
          ],
        ),
        const SizedBox(height: 12),
        _buildDetailItem(Icons.payment_rounded, 'Payment Status', widget.appointment.paymentStatus.capitalizeFirst ?? 'Pending', valueColor: _getPaymentStatusColor(widget.appointment.paymentStatus)),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 15, color: valueColor ?? AppTheme.textPrimary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
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
              'Patient Information',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            _buildMedicalInfoItem('Age', widget.appointment.patientAge ?? 'Not specified'),
            const SizedBox(height: 12),
            _buildMedicalInfoItem('Gender', widget.appointment.patientGender ?? 'Not specified'),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalInfoItem(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (widget.appointment.status.toLowerCase() != 'scheduled' && widget.appointment.status.toLowerCase() != 'confirmed') {
      return SizedBox.shrink();
    }
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
            if (widget.appointment.status.toLowerCase() == 'scheduled')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _confirmAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Confirm Booking',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancelAppointment,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: AppTheme.emergencyRed),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.emergencyRed),
                      ),
                    ),
                  ),
                ],
              ),
            if (widget.appointment.status.toLowerCase() == 'confirmed')
              ElevatedButton(
                onPressed: _completeAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: Text(
                  'Complete Booking',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                ),
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
                decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.check_circle_rounded, color: AppTheme.accentGreen, size: 40),
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
                      onPressed: () => Get.back(),
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
                        Get.back();
                        _updateAppointmentStatus('confirmed', 'Appointment confirmed successfully');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGreen,
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
                      onPressed: () => Get.back(),
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
                        Get.back();
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
                      onPressed: () => Get.back(),
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
                        Get.back();
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
        Get.snackbar('Success', successMessage, snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.accentGreen, colorText: Colors.white, borderRadius: 12);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update appointment status', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.emergencyRed, colorText: Colors.white, borderRadius: 12);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppTheme.accentGreen;
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
        return AppTheme.accentGreen;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return AppTheme.emergencyRed;
      default:
        return AppTheme.textPrimary;
    }
  }
}
