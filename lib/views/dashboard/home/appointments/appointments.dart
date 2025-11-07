import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
          body: RefreshIndicator(
            onRefresh: () => ctrl.refreshAppointments(),
            child: CustomScrollView(
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
                      Obx(() => Text('${ctrl.allAppointments.length} total appointments', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary))),
                    ],
                  ),
                  bottom: PreferredSize(preferredSize: const Size.fromHeight(80), child: _buildFilterSection(ctrl)),
                ),
                Obx(() {
                  if (ctrl.isLoading.value && ctrl.allAppointments.isEmpty) {
                    return SliverFillRemaining(child: _buildLoadingState());
                  }
                  if (ctrl.allAppointments.isEmpty) {
                    return SliverFillRemaining(child: _buildEmptyState(ctrl));
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == ctrl.allAppointments.length) {
                          if (ctrl.isLoadingMore.value) {
                            return _buildLoadingMore();
                          }
                          if (ctrl.hasMore) {
                            ctrl.loadMoreAppointments();
                            return _buildLoadingMore();
                          }
                          return _buildNoMoreAppointments();
                        }
                        final appointment = ctrl.allAppointments[index];
                        return _buildAppointmentCard(appointment, ctrl);
                      }, childCount: ctrl.allAppointments.length + 1),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(AppointmentsCtrl ctrl) {
    return Container(
      color: AppTheme.backgroundWhite,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
      child: Column(
        children: [
          Obx(() {
            return SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildStatusFilterChip('All', '', ctrl),
                  _buildStatusFilterChip('Scheduled', 'scheduled', ctrl),
                  _buildStatusFilterChip('Confirmed', 'confirmed', ctrl),
                  _buildStatusFilterChip('Completed', 'completed', ctrl),
                  _buildStatusFilterChip('Cancelled', 'cancelled', ctrl),
                  _buildStatusFilterChip('No-Show', 'no-show', ctrl),
                  _buildStatusFilterChip('Rescheduled', 'rescheduled', ctrl),
                ],
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
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
        selected: isSelected,
        onSelected: (selected) {
          ctrl.filterAppointmentsByStatus(selected ? value : '');
        },
        backgroundColor: AppTheme.backgroundLight,
        selectedColor: statusColor.withOpacity(0.15),
        labelStyle: GoogleFonts.inter(color: isSelected ? statusColor : AppTheme.textPrimary, fontWeight: FontWeight.w500),
        checkmarkColor: statusColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: isSelected ? statusColor : AppTheme.borderColor, width: isSelected ? 1.5 : 1),
        ),
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
          onTap: () async {
            await Get.to(() => AppointmentDetails(appointment: appointment));
            await ctrl.refreshAppointments();
          },
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appointment.patientName,
                                      style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(appointment.serviceName ?? 'Consultation', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildStatusBadge(appointment.status, statusColor, statusIcon),
                            ],
                          ),
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
                          Expanded(child: _buildAppointmentDetail(Icons.calendar_today_rounded, 'Date', DateFormat('MMM dd, yyyy').format(appointment.appointmentDate))),
                          Expanded(child: _buildAppointmentDetail(Icons.access_time_rounded, 'Time', appointment.appointmentTime)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildAppointmentDetail(Icons.medical_services_rounded, 'Service', appointment.consultationType)),
                          if (appointment.isUrgent) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.warning_rounded, size: 12, color: Colors.red),
                                  const SizedBox(width: 4),
                                  Text(
                                    'URGENT',
                                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildActionButtons(appointment, ctrl),
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

  Widget _buildActionButtons(AppointmentModel appointment, AppointmentsCtrl ctrl) {
    final status = appointment.status.toLowerCase();
    if (status == 'scheduled') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => ctrl.updateAppointmentStatus(appointment.id, 'confirmed'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                side: BorderSide(color: AppTheme.accentGreen),
              ),
              child: Text(
                'Confirm',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.accentGreen),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => ctrl.updateAppointmentStatus(appointment.id, 'cancelled'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                side: BorderSide(color: AppTheme.emergencyRed),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.emergencyRed),
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () async {
            await Get.to(() => AppointmentDetails(appointment: appointment));
            await ctrl.refreshAppointments();
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(color: AppTheme.primaryBlue),
          ),
          child: Text(
            'View Details',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
          ),
        ),
      );
    }
  }

  Widget _buildLoadingMore() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryBlue)),
      ),
    );
  }

  Widget _buildNoMoreAppointments() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text('No more appointments', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
      ),
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
              ctrl.selectedStatus.value.isEmpty ? 'No Appointments Found' : 'No ${ctrl.selectedStatus.value.capitalizeFirst} Appointments',
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(
              ctrl.selectedStatus.value.isEmpty ? 'You don\'t have any appointments yet' : 'No ${ctrl.selectedStatus.value.capitalizeFirst} appointments match your criteria',
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textLight, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (ctrl.selectedStatus.value.isNotEmpty)
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
                  'Clear Filters',
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
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.purple;
      case 'no-show':
        return Colors.grey;
      case 'rescheduled':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle_outline_rounded;
      case 'scheduled':
        return Icons.schedule_rounded;
      case 'pending':
        return Icons.pending_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'completed':
        return Icons.verified_rounded;
      case 'no-show':
        return Icons.person_off_rounded;
      case 'rescheduled':
        return Icons.calendar_today_rounded;
      default:
        return Icons.calendar_today_rounded;
    }
  }
}
