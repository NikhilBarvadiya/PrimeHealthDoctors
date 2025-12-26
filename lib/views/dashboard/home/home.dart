import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prime_health_doctors/utils/decoration.dart';
import 'package:prime_health_doctors/utils/network/api_config.dart';
import 'package:prime_health_doctors/views/dashboard/profile/ui/slots_management.dart';
import 'package:prime_health_doctors/models/appointment_model.dart';
import 'package:prime_health_doctors/models/patient_model.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/dashboard/dashboard_ctrl.dart';
import 'package:prime_health_doctors/views/dashboard/home/call_history/call_history.dart';
import 'package:prime_health_doctors/views/dashboard/home/home_ctrl.dart';
import 'package:prime_health_doctors/views/dashboard/home/appointments/ui/appointment_details.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeCtrl>(
      init: HomeCtrl(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          body: RefreshIndicator(
            onRefresh: () async => await ctrl.onAPICalling(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _buildAppBar(ctrl),
                SliverToBoxAdapter(
                  child: Obx(() {
                    if (ctrl.isLoading.value && ctrl.consultedPatients.isEmpty && ctrl.todayAppointments.isEmpty) {
                      return _buildFullShimmer();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildWelcomeCard(ctrl),
                        const SizedBox(height: 24),
                        _buildNextAppointmentsSection(ctrl),
                        const SizedBox(height: 24),
                        _buildConsultedPatientsSection(ctrl),
                        const SizedBox(height: 24),
                        _buildAppointmentsSection(ctrl),
                        const SizedBox(height: 32),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  SliverAppBar _buildAppBar(HomeCtrl ctrl) {
    return SliverAppBar(
      elevation: 0,
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      pinned: true,
      floating: true,
      expandedHeight: 100,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        collapseMode: CollapseMode.pin,
        background: Container(color: Colors.white),
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi ${ctrl.userName.value.split(' ').first}!',
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Welcome back!',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            padding: WidgetStatePropertyAll(const EdgeInsets.all(8)),
            backgroundColor: WidgetStatePropertyAll(Colors.white),
            side: WidgetStatePropertyAll(BorderSide(color: decoration.colorScheme.primary.withOpacity(.1))),
          ),
          icon: Icon(Icons.schedule_rounded, color: decoration.colorScheme.primary, size: 20),
          onPressed: () => Get.to(() => SlotsManagement()),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              padding: WidgetStatePropertyAll(const EdgeInsets.all(8)),
              backgroundColor: WidgetStatePropertyAll(Colors.white),
              side: WidgetStatePropertyAll(BorderSide(color: decoration.colorScheme.primary.withOpacity(.1))),
            ),
            icon: Icon(Icons.contacts, color: decoration.colorScheme.primary, size: 20),
            onPressed: () => Get.to(() => CallHistory()),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(HomeCtrl ctrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primaryBlue.withOpacity(0.9), AppTheme.accentTeal]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's take the next step",
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  "for your health!",
                  style: GoogleFonts.inter(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    'View Insights',
                    style: GoogleFonts.inter(fontSize: 14, color: AppTheme.primaryBlue, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
            child: Icon(Icons.health_and_safety_rounded, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildNextAppointmentsSection(HomeCtrl ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Next Appointments',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Obx(
                  () => Text(
                    '${ctrl.todayAppointmentsCount}',
                    style: GoogleFonts.inter(fontSize: 14, color: AppTheme.primaryBlue, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (ctrl.isLoading.value && ctrl.todayAppointments.isEmpty) {
              return _buildAppointmentCardShimmer();
            }
            if (ctrl.todayAppointments.isEmpty) {
              return _buildEmptyAppointmentCard();
            }
            return _buildNextAppointmentCard(ctrl.todayAppointments.first);
          }),
        ],
      ),
    );
  }

  Widget _buildNextAppointmentCard(AppointmentModel appointment) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.to(() => AppointmentDetails(appointment: appointment)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.accentTeal]),
                      ),
                      child: Center(
                        child: Text(
                          appointment.patientName.split(' ').map((n) => n[0]).join(),
                          style: GoogleFonts.inter(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        'Join',
                        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.primaryBlue, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  appointment.patientName,
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
                Text(appointment.serviceName ?? 'Consultation', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 14, color: AppTheme.textLight),
                    const SizedBox(width: 4),
                    Text(DateFormat('dd MMMM, EEEE').format(appointment.appointmentDate), style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time_rounded, size: 14, color: AppTheme.textLight),
                    const SizedBox(width: 4),
                    Text(appointment.appointmentTime, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConsultedPatientsSection(HomeCtrl ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Patients',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              Obx(
                () => Text(
                  '${ctrl.consultedPatients.length} Total',
                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (ctrl.isLoadingPatients.value && ctrl.consultedPatients.isEmpty) {
              return _buildPatientsShimmer();
            }
            if (ctrl.consultedPatients.isEmpty) {
              return _buildEmptyState('No Patients Yet', 'Patients you consult will appear here', Icons.people_outline_rounded);
            }
            return _buildPatientsList(ctrl);
          }),
        ],
      ),
    );
  }

  Widget _buildPatientsList(HomeCtrl ctrl) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(children: [...ctrl.consultedPatients.map((e) => _buildPatientCard(e))]),
    );
  }

  Widget _buildPatientCard(PatientModel patient) {
    final String? imageUrl = patient.profileImage;
    final String displayImageUrl = imageUrl != null && imageUrl.isNotEmpty ? APIConfig.resourceBaseURL + imageUrl : '';
    return Container(
      width: Get.width * 0.4,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2), width: 2),
            ),
            child: ClipOval(
              child: displayImageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: displayImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.backgroundLight,
                        child: const Icon(Icons.person, color: AppTheme.textLight, size: 30),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.backgroundLight,
                        child: const Icon(Icons.person, color: AppTheme.textLight, size: 30),
                      ),
                    )
                  : Container(
                      color: AppTheme.backgroundLight,
                      child: const Icon(Icons.person, color: AppTheme.textLight, size: 30),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            patient.name,
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text("Blood Group: ${patient.bloodGroup}", style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
          Text("Gender: ${patient.gender}", style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildAppointmentsSection(HomeCtrl ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Appointments",
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              TextButton(
                onPressed: () {
                  final dashboardCtrl = Get.find<DashboardCtrl>();
                  dashboardCtrl.changeTab(1);
                },
                style: TextButton.styleFrom(foregroundColor: AppTheme.primaryBlue, padding: EdgeInsets.zero),
                child: Obx(() => Text('View All (${ctrl.todayAppointmentsCount})', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (ctrl.isLoading.value && ctrl.todayAppointments.isEmpty) {
              return _buildAppointmentsShimmer();
            }
            if (ctrl.todayAppointments.isEmpty) {
              return _buildEmptyState('No Appointments Today', 'No appointments scheduled for today', Icons.calendar_today_outlined);
            }
            return _buildAppointmentsList(ctrl);
          }),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(HomeCtrl ctrl) {
    return Column(children: ctrl.todayAppointments.take(5).map((appointment) => _buildAppointmentCard(ctrl, appointment)).toList());
  }

  Widget _buildAppointmentCard(HomeCtrl ctrl, AppointmentModel appointment) {
    final statusColor = _getStatusColor(appointment.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            await Get.to(() => AppointmentDetails(appointment: appointment)) ?? false;
            await ctrl.loadTodayAppointments();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Icon(_getStatusIcon(appointment.status), color: statusColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.patientName,
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(appointment.serviceName ?? 'Consultation', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        appointment.statusDisplay.toUpperCase(),
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildAppointmentDetails(appointment),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentDetails(AppointmentModel appointment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppTheme.backgroundLight, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          _buildDetailItem(Icons.calendar_today_rounded, DateFormat('MMM dd, yyyy').format(appointment.appointmentDate), AppTheme.textSecondary),
          _buildDetailItem(Icons.access_time_rounded, appointment.appointmentTime, AppTheme.textSecondary),
          _buildDetailItem(Icons.medical_services_rounded, appointment.consultationType, AppTheme.textSecondary),
          if (appointment.isUrgent) _buildDetailItem(Icons.warning_amber_rounded, 'Urgent', AppTheme.emergencyRed),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text, Color color) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 12, color: color, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppTheme.textLight),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(color: AppTheme.textSecondary, fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'scheduled':
        return AppTheme.successGreen;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
      case 'no-show':
        return AppTheme.emergencyRed;
      case 'completed':
        return AppTheme.primaryBlue;
      case 'rescheduled':
        return Colors.purple;
      default:
        return AppTheme.textLight;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'scheduled':
        return Icons.schedule_rounded;
      case 'confirmed':
        return Icons.check_circle_rounded;
      case 'completed':
        return Icons.verified_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'no-show':
        return Icons.no_accounts_rounded;
      case 'rescheduled':
        return Icons.calendar_today_rounded;
      default:
        return Icons.calendar_today_rounded;
    }
  }

  Widget _buildFullShimmer() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildWelcomeCardShimmer(),
        const SizedBox(height: 24),
        _buildAppointmentCardShimmer(),
        const SizedBox(height: 24),
        _buildPatientsShimmer(),
        const SizedBox(height: 24),
        _buildAppointmentsShimmer(),
      ],
    );
  }

  Widget _buildWelcomeCardShimmer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey[200]),
    );
  }

  Widget _buildAppointmentCardShimmer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.grey[200]),
    );
  }

  Widget _buildEmptyAppointmentCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_today_outlined, size: 48, color: AppTheme.textLight),
          const SizedBox(height: 12),
          Text(
            'No appointments scheduled',
            style: GoogleFonts.inter(color: AppTheme.textSecondary, fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Your next appointment will appear here',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 150, height: 20, color: Colors.grey[200]),
              Container(width: 60, height: 16, color: Colors.grey[200]),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 180, height: 20, color: Colors.grey[200]),
              Container(width: 80, height: 16, color: Colors.grey[200]),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: List.generate(
              2,
              (index) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
