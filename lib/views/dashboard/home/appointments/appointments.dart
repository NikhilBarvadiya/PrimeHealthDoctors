import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/models/appointment_model.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/dashboard/home/appointments/appointments_ctrl.dart';
import 'package:prime_health_doctors/views/dashboard/home/appointments/ui/appointment_details.dart';

class Appointments extends StatelessWidget {
  const Appointments({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentsCtrl>(
      init: AppointmentsCtrl(),
      builder: (ctrl) {
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
                automaticallyImplyLeading: false,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointments',
                      style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text('${ctrl.filteredAppointments.length} total appointments', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary))),
                  ],
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
                bottom: PreferredSize(preferredSize: const Size.fromHeight(138), child: _buildSearchSection(ctrl)),
              ),
              Obx(() {
                if (ctrl.isLoading.value) {
                  return SliverFillRemaining(child: _buildLoadingState());
                }
                return ctrl.filteredAppointments.isEmpty
                    ? SliverFillRemaining(child: _buildEmptyState(ctrl))
                    : SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final appointment = ctrl.filteredAppointments[index];
                            return _buildAppointmentCard(appointment, ctrl);
                          }, childCount: ctrl.filteredAppointments.length),
                        ),
                      );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchSection(AppointmentsCtrl ctrl) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 6, bottom: 8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: TextField(
              controller: ctrl.searchController,
              decoration: InputDecoration(
                hintText: 'Search appointments...',
                hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.search_rounded, color: AppTheme.textSecondary, size: 22),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                suffixIcon: ctrl.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear_rounded, color: AppTheme.textLight, size: 20),
                        onPressed: () {
                          ctrl.searchController.clear();
                          ctrl.searchAppointments('');
                        },
                      )
                    : null,
              ),
              onChanged: ctrl.searchAppointments,
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            return SizedBox(
              height: 60,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10.0,
                  children: [
                    _buildStatusFilterChip('All', '', ctrl),
                    _buildStatusFilterChip('Confirmed', 'confirmed', ctrl),
                    _buildStatusFilterChip('Pending', 'pending', ctrl),
                    _buildStatusFilterChip('Cancelled', 'cancelled', ctrl),
                    _buildStatusFilterChip('Completed', 'completed', ctrl),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatusFilterChip(String label, String value, AppointmentsCtrl ctrl) {
    final isSelected = ctrl.selectedStatus.value == value;
    final statusColor = _getStatusColor(value.isEmpty ? 'all' : value);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        ctrl.filterAppointmentsByStatus(selected ? value : '');
      },
      backgroundColor: AppTheme.backgroundLight,
      selectedColor: statusColor.withOpacity(0.1),
      labelStyle: GoogleFonts.inter(color: isSelected ? statusColor : AppTheme.textPrimary, fontWeight: FontWeight.w500),
      checkmarkColor: statusColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: isSelected ? statusColor : AppTheme.borderColor),
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment, AppointmentsCtrl ctrl) {
    final statusColor = _getStatusColor(appointment.status);
    final statusIcon = _getStatusIcon(appointment.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.to(() => AppointmentDetails(appointment: appointment)),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.person_rounded, color: AppTheme.primaryBlue, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  appointment.patientName,
                                  style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildStatusBadge(appointment.status, statusColor, statusIcon),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(appointment.service, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppTheme.backgroundLight, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildAppointmentDetail(Icons.calendar_today_rounded, 'Date', appointment.date)),
                          Expanded(child: _buildAppointmentDetail(Icons.access_time_rounded, 'Time', appointment.time)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildAppointmentDetail(Icons.medical_services_rounded, 'Service', appointment.service),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (appointment.status.toLowerCase() == 'pending')
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => ctrl.updateAppointmentStatus(appointment.id.toString(), 'confirmed'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: BorderSide(color: AppTheme.accentGreen),
                          ),
                          child: Text(
                            'Confirm',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.accentGreen),
                          ),
                        ),
                      ),
                    if (appointment.status.toLowerCase() == 'pending') const SizedBox(width: 8),
                    if (appointment.status.toLowerCase() == 'pending')
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => ctrl.updateAppointmentStatus(appointment.id.toString(), 'cancelled'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: BorderSide(color: AppTheme.emergencyRed),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.emergencyRed),
                          ),
                        ),
                      ),
                    if (appointment.status.toLowerCase() != 'pending')
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.to(() => AppointmentDetails(appointment: appointment)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: BorderSide(color: AppTheme.primaryBlue),
                          ),
                          child: Text(
                            'View Details',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.capitalizeFirst!,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetail(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppTheme.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 3, color: AppTheme.primaryBlue)),
          const SizedBox(height: 16),
          Text(
            'Loading Appointments...',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppointmentsCtrl ctrl) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_rounded, size: 80, color: AppTheme.textLight.withOpacity(0.4)),
            const SizedBox(height: 24),
            Text(
              'No Appointments Found',
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your search criteria or clear filters to see all appointments',
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textLight, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ctrl.clearAllFilters();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Clear All Filters',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
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
