import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:prime_health_doctors/models/appointment_model.dart';
import 'package:prime_health_doctors/utils/decoration.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/dashboard/home/appointments/appointments.dart';
import 'package:prime_health_doctors/views/dashboard/home/appointments/ui/appointment_details.dart';
import 'package:prime_health_doctors/views/dashboard/home/home_ctrl.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeCtrl>(
      init: HomeCtrl(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                toolbarHeight: 65,
                backgroundColor: Colors.white,
                pinned: true,
                floating: true,
                expandedHeight: 120,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(color: Colors.white),
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello,', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                        Text(
                          ctrl.userName.value,
                          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: Badge(
                        smallSize: 8,
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.notifications_outlined, color: Colors.black87),
                      ),
                      onPressed: () => Get.snackbar('Notifications', 'No new notifications', snackPosition: SnackPosition.BOTTOM),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [const SizedBox(height: 20), _buildBannerSection(), const SizedBox(height: 32), _buildAppointmentsSection(ctrl), const SizedBox(height: 20)],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBannerSection() {
    final banners = [
      {
        'image': 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
        'title': 'Excellence in Healthcare',
        'subtitle': 'Providing world-class medical care with compassion and expertise',
        'gradient': [AppTheme.primaryBlue, AppTheme.primaryDark],
      },
      {
        'image': 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2073&q=80',
        'title': 'Advanced Medical Technology',
        'subtitle': 'State-of-the-art equipment for accurate diagnosis and treatment',
        'gradient': [AppTheme.accentTeal, AppTheme.accentGreen],
      },
      {
        'image': 'https://images.unsplash.com/photo-1551601651-2a8555f1a136?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2032&q=80',
        'title': 'Patient-Centered Care',
        'subtitle': 'Your health and wellbeing are our top priorities',
        'gradient': [Color(0xFF8B5CF6), Color(0xFF6366F1)],
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
          final gradientColors = (banner['gradient'] as List<Color>);
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
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                        ),
                        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                        ),
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
                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(banner['subtitle'].toString(), style: GoogleFonts.poppins(fontSize: 14, color: Colors.white.withOpacity(0.9))),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          banners.length,
                          (i) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: i == index ? Colors.white : Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentsSection(HomeCtrl ctrl) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Today\'s Appointments',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              TextButton(
                onPressed: () => Get.to(() => const Appointments(), transition: Transition.rightToLeft),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                child: Obx(
                  () => Text(
                    'View All (${ctrl.filteredAppointments.length})',
                    style: GoogleFonts.poppins(color: decoration.colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(
            () => ctrl.filteredAppointments.isEmpty
                ? _buildEmptyState(icon: Icons.calendar_today_outlined, title: 'No Appointments', subtitle: 'No appointments scheduled for today')
                : SizedBox(
                    height: 165,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: ctrl.filteredAppointments.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final appointment = ctrl.filteredAppointments[index];
                        return _buildAppointmentCard(appointment);
                      },
                    ),
                  ).paddingOnly(right: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    Color statusColor = _getStatusColor(appointment.status);
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.to(() => AppointmentDetails(appointment: appointment)),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: decoration.colorScheme.primary.withOpacity(0.1),
                      child: Icon(Icons.person, color: decoration.colorScheme.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        appointment.patientName,
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildInfoRow(Icons.calendar_today_outlined, appointment.date), _buildInfoRow(Icons.access_time_outlined, appointment.time)],
                ),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.medical_services_outlined, appointment.service),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        appointment.status.capitalizeFirst.toString(),
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: statusColor),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildEmptyState({required IconData icon, required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
