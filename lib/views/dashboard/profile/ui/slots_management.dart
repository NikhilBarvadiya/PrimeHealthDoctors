import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/dashboard/profile/profile_ctrl.dart';

class SlotsManagement extends StatefulWidget {
  const SlotsManagement({super.key});

  @override
  State<SlotsManagement> createState() => _SlotsManagementState();
}

class _SlotsManagementState extends State<SlotsManagement> {
  final ProfileCtrl ctrl = Get.find<ProfileCtrl>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ctrl.loadSlots(refresh: true);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      ctrl.loadMoreSlots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.backgroundWhite,
        title: Text(
          'Time Slots Management',
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
            icon: Icon(Icons.filter_list_rounded, color: AppTheme.primaryBlue, size: 24),
            onPressed: _showFiltersDialog,
            tooltip: 'Filter Slots',
          ),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.backgroundLight,
              padding: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.add_rounded, color: AppTheme.primaryBlue, size: 24),
            onPressed: _showAddSlotDialog,
            tooltip: 'Add New Slot',
          ),
          SizedBox(width: 10.0),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoadingSlots.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () async => await ctrl.loadSlots(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(),
                      const SizedBox(height: 20),
                      _buildFiltersSummary(),
                      const SizedBox(height: 20),
                      _buildSectionHeader('Your Time Slots'),
                      const SizedBox(height: 8),
                      Text('Manage your appointment time slots. Recurring slots repeat weekly.', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
              ),
              _buildSlotsList(),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time Slots Info',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Create time slots for patient appointments. Recurring slots automatically repeat every week.',
                  style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSummary() {
    return Obx(() {
      final hasActiveFilters = ctrl.startDate.value != null || ctrl.endDate.value != null;
      if (!hasActiveFilters) return const SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          children: [
            Icon(Icons.filter_alt_rounded, size: 16, color: AppTheme.primaryBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _getFilterSummaryText(),
                style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: ctrl.clearSlotsFilters,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.emergencyRed.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(
                  'Clear',
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.emergencyRed),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  String _getFilterSummaryText() {
    final List<String> filters = [];
    if (ctrl.startDate.value != null) {
      filters.add('From: ${_formatDate(ctrl.startDate.value!)}');
    }
    if (ctrl.endDate.value != null) {
      filters.add('To: ${_formatDate(ctrl.endDate.value!)}');
    }
    return filters.join(' • ');
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
    );
  }

  Widget _buildSlotsList() {
    return Obx(() {
      if (ctrl.slots.isEmpty) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Icon(Icons.schedule_rounded, size: 64, color: AppTheme.textLight.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No Time Slots',
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first time slot to start accepting appointments',
                    style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textLight),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showAddSlotDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Add First Slot',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final slot = ctrl.slots[index];
          return _buildSlotItem(slot, index);
        }, childCount: ctrl.slots.length),
      );
    });
  }

  Widget _buildSlotItem(Map<String, dynamic> slot, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: ctrl.isRecurringSlot(slot) ? AppTheme.accentGreen.withOpacity(0.1) : AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(ctrl.isRecurringSlot(slot) ? Icons.repeat_rounded : Icons.event_rounded, color: ctrl.isRecurringSlot(slot) ? AppTheme.accentGreen : AppTheme.primaryBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${ctrl.formatSlotTime(slot['startTime'])} - ${ctrl.formatSlotTime(slot['endTime'])}',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(width: 8),
                    if (ctrl.isRecurringSlot(slot))
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          'Recurring',
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.accentGreen),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Date: ${ctrl.formatSlotDate(slot['startTime'])}', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                const SizedBox(height: 4),
                Text('Duration: ${_calculateDuration(slot['startTime'], slot['endTime'])}', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textLight)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showDeleteSlotDialog(index),
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  String _calculateDuration(String startTime, String endTime) {
    try {
      final start = DateTime.parse(startTime);
      final end = DateTime.parse(endTime);
      final difference = end.difference(start);
      final minutes = difference.inMinutes;

      if (minutes < 60) {
        return '$minutes min';
      } else {
        final hours = minutes ~/ 60;
        final remainingMinutes = minutes % 60;
        return remainingMinutes > 0 ? '$hours h $remainingMinutes min' : '$hours h';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  void _showFiltersDialog() {
    DateTime? startDate = ctrl.startDate.value;
    DateTime? endDate = ctrl.endDate.value;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter Slots',
                    style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date Range',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(context: context, initialDate: startDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                                if (date != null) {
                                  setState(() => startDate = date);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.borderColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(startDate != null ? _formatDate(startDate!) : 'Start Date', style: GoogleFonts.inter(color: startDate != null ? AppTheme.textPrimary : AppTheme.textLight)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(context: context, initialDate: endDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                                if (date != null) {
                                  setState(() => endDate = date);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.borderColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(endDate != null ? _formatDate(endDate!) : 'End Date', style: GoogleFonts.inter(color: endDate != null ? AppTheme.textPrimary : AppTheme.textLight)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: AppTheme.borderColor),
                          ),
                          child: Text('Cancel', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ctrl.applySlotsFilters(start: startDate, end: endDate);
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Apply Filters',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddSlotDialog() {
    final startTime = TimeOfDay.now();
    final endTime = TimeOfDay(hour: startTime.hour + 1, minute: startTime.minute);
    final selectedDate = DateTime.now();
    var isRecurring = true;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(Icons.add_rounded, color: AppTheme.primaryBlue, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Add Time Slot',
                    style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 20),
                  _buildTimePicker('Start Time', startTime, (time) {}),
                  const SizedBox(height: 16),
                  _buildTimePicker('End Time', endTime, (time) {}),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(value: isRecurring, onChanged: (value) => setState(() => isRecurring = value ?? true), activeColor: AppTheme.primaryBlue),
                      Expanded(
                        child: Text('Recurring slot (repeat weekly)', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: AppTheme.borderColor),
                          ),
                          child: Text('Cancel', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final newSlot = {'startTime': _createDateTimeString(selectedDate, startTime), 'endTime': _createDateTimeString(selectedDate, endTime), 'isRecurring': isRecurring};
                            _addNewSlot(newSlot);
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Add Slot',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteSlotDialog(int index) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.emergencyRed.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.delete_rounded, color: AppTheme.emergencyRed, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Delete Slot',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to delete this time slot?',
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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: AppTheme.borderColor),
                      ),
                      child: Text('Cancel', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _deleteSlot(index);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.emergencyRed,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, Function(TimeOfDay) onTimeChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: time,
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: AppTheme.primaryBlue)),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              onTimeChanged(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTimeOfDay(time),
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                ),
                Icon(Icons.access_time_rounded, color: AppTheme.textLight),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _createDateTimeString(DateTime date, TimeOfDay time) {
    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return dateTime.toUtc().toIso8601String();
  }

  void _addNewSlot(Map<String, dynamic> newSlot) => ctrl.manageSlots([newSlot]);

  Future<void> _deleteSlot(int index) async => await ctrl.deleteSlots(index);
}
