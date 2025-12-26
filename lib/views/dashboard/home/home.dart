import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prime_health_doctors/models/appointment_model.dart';
import 'package:prime_health_doctors/models/patient_model.dart';
import 'package:prime_health_doctors/utils/network/api_config.dart';
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
                        _buildBannerSection(),
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
        title: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: ctrl.isLoading.value
                ? _buildAppBarShimmer()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good ${_getGreeting()}!',
                        style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ctrl.userName.value,
                        style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              padding: WidgetStatePropertyAll(const EdgeInsets.all(8)),
              backgroundColor: WidgetStatePropertyAll(Colors.grey[100]),
            ),
            icon: const Icon(Icons.contacts, color: Colors.black87, size: 20),
            onPressed: () => Get.to(() => CallHistory()),
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildAppBarShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 14,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(height: 6),
          Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
          ),
        ],
      ),
    );
  }

  Widget _buildFullShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Column(children: [_buildBannerShimmer(), const SizedBox(height: 24), _buildPatientsShimmer(), const SizedBox(height: 24), _buildAppointmentsShimmer()]),
    );
  }

  Widget _buildBannerShimmer() {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        itemCount: 3,
        padEnds: false,
        controller: PageController(viewportFraction: 0.85),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade50,
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              ),
            ),
          );
        },
      ),
    ).paddingOnly(left: 5, right: 5);
  }

  Widget _buildPatientsShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 150,
                height: 20,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              ),
              const Spacer(),
              Container(
                width: 50,
                height: 16,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: Get.width * 0.75,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 16,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 100,
                              height: 12,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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
            children: [
              Container(
                width: 180,
                height: 20,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              ),
              const Spacer(),
              Container(
                width: 50,
                height: 16,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(children: List.generate(3, (index) => _buildAppointmentCardShimmer())),
        ],
      ),
    );
  }

  Widget _buildAppointmentCardShimmer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 20, backgroundColor: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 120, height: 16, child: ColoredBox(color: Colors.white)),
                      SizedBox(height: 4),
                      SizedBox(width: 80, height: 12, child: ColoredBox(color: Colors.white)),
                    ],
                  ),
                ),
                SizedBox(width: 60, height: 24, child: ColoredBox(color: Colors.white)),
              ],
            ),
            SizedBox(height: 12),
            SizedBox(height: 40, child: ColoredBox(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSection() {
    final banners = [
      {
        'image': 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80',
        'title': 'Excellence in Healthcare',
        'subtitle': 'Providing world-class medical care with compassion and expertise',
        'color': AppTheme.primaryBlue,
      },
      {
        'image': 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?ixlib=rb-4.0.3&auto=format&fit=crop&w=2073&q=80',
        'title': 'Advanced Medical Technology',
        'subtitle': 'State-of-the-art equipment for accurate diagnosis and treatment',
        'color': AppTheme.accentTeal,
      },
      {
        'image': 'https://images.unsplash.com/photo-1551601651-2a8555f1a136?ixlib=rb-4.0.3&auto=format&fit=crop&w=2032&q=80',
        'title': 'Patient-Centered Care',
        'subtitle': 'Your health and wellbeing are our top priorities',
        'color': AppTheme.accentGreen,
      },
    ];

    return SizedBox(
      height: 160,
      child: PageView.builder(
        itemCount: banners.length,
        padEnds: false,
        controller: PageController(viewportFraction: 0.85),
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: banner['image'].toString(),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: banner['color'] as Color,
                        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: banner['color'] as Color,
                        child: const Icon(Icons.error, color: Colors.white, size: 40),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.black.withOpacity(0.6), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner['title'].toString(),
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(banner['subtitle'].toString(), style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withOpacity(0.9))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ).paddingOnly(left: 5, right: 5);
  }

  Widget _buildConsultedPatientsSection(HomeCtrl ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Patients',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const Spacer(),
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
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: ctrl.consultedPatients.length,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        itemBuilder: (context, index) {
          final patient = ctrl.consultedPatients[index];
          return _buildPatientCard(patient);
        },
      ),
    );
  }

  Widget _buildPatientCard(PatientModel patient) {
    final String? imageUrl = patient.profileImage;
    final String displayImageUrl = imageUrl != null && imageUrl.isNotEmpty ? APIConfig.resourceBaseURL + imageUrl : '';
    return Container(
      width: Get.width * 0.75,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        patient.name,
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Blood Group: ${patient.bloodGroup}", style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                          ),
                          Text("Gender: ${patient.gender}", style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
            children: [
              Text(
                'Today\'s Appointments',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const Spacer(),
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
}
