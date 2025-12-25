import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/dashboard/profile/profile_ctrl.dart';
import 'package:shimmer/shimmer.dart';

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
        backgroundColor: Colors.white,
        title: Text(
          'Time Slots Management',
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
        ),
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey[100],
            padding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary, size: 24),
          onPressed: () => Get.close(1),
        ),
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              padding: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.filter_list_rounded, color: AppTheme.primaryBlue, size: 20),
            onPressed: _showFiltersDialog,
            tooltip: 'Filter Slots',
          ),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.add_rounded, color: Colors.white, size: 20),
            onPressed: _showAddSlotDialog,
            tooltip: 'Add New Slot',
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async => await ctrl.loadSlots(),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(),
                      const SizedBox(height: 16),
                      _buildFiltersSummary(),
                      const SizedBox(height: 10),
                      _buildSectionHeader('Your Time Slots'),
                      const SizedBox(height: 4),
                      Text('Manage your appointment time slots. Recurring slots repeat weekly.', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
              ),
              _buildSlotsList(),
              if (ctrl.isLoadingSlots.value) _buildLoadingMoreSlots(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 20),
          ),
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
                Text('Create time slots for patient appointments. Recurring slots automatically repeat every week.', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: Icon(Icons.filter_alt_rounded, size: 14, color: AppTheme.primaryBlue),
            ),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close_rounded, size: 12, color: AppTheme.emergencyRed),
                    const SizedBox(width: 4),
                    Text(
                      'Clear',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.emergencyRed),
                    ),
                  ],
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
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
    );
  }

  Widget _buildSlotsList() {
    return Obx(() {
      if (ctrl.isLoadingSlots.value) {
        return SliverList(delegate: SliverChildBuilderDelegate((context, index) => _buildSlotShimmerItem(), childCount: 6));
      }
      if (ctrl.slots.isEmpty) {
        return SliverToBoxAdapter(
          child: Padding(padding: const EdgeInsets.all(20), child: _buildEmptyState()),
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

  Widget _buildSlotShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 16,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 60,
                    height: 12,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotItem(Map<String, dynamic> slot, int index) {
    final isRecurring = ctrl.isRecurringSlot(slot);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showSlotDetails(slot),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${ctrl.formatSlotTime(slot['startTime'])} - ${ctrl.formatSlotTime(slot['endTime'])}',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text('Date: ${ctrl.formatSlotDate(slot['startTime'])}', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                      const SizedBox(height: 4),
                      Text('Duration: ${_calculateDuration(slot['startTime'], slot['endTime'])}', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textLight)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isRecurring)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.successGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.repeat_rounded, size: 10, color: AppTheme.successGreen),
                            const SizedBox(width: 4),
                            Text(
                              'Recurring',
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.successGreen),
                            ),
                          ],
                        ),
                      ),
                    if (!isRecurring)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.event_rounded, size: 10, color: AppTheme.primaryBlue),
                            const SizedBox(width: 4),
                            Text(
                              'Event',
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.emergencyRed.withOpacity(.1),
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: Icon(Icons.delete_outline_rounded, color: AppTheme.emergencyRed, size: 20),
                      onPressed: () => _showDeleteSlotDialog(index),
                      tooltip: 'Delete Slot',
                    ),
                  ],
                ).paddingOnly(right: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: AppTheme.backgroundLight, shape: BoxShape.circle),
            child: Icon(Icons.schedule_rounded, size: 40, color: AppTheme.textLight),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _showAddSlotDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Add First Slot', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreSlots() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryBlue)),
        ),
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

  void _showSlotDetails(Map<String, dynamic> slot) {
    final isRecurring = ctrl.isRecurringSlot(slot);
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: isRecurring ? AppTheme.successGreen.withOpacity(0.1) : AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(isRecurring ? Icons.repeat_rounded : Icons.event_rounded, color: isRecurring ? AppTheme.successGreen : AppTheme.primaryBlue, size: 30),
              ),
              const SizedBox(height: 16),
              Text(
                'Slot Details',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 16),
              _buildDetailItem('Time', '${ctrl.formatSlotTime(slot['startTime'])} - ${ctrl.formatSlotTime(slot['endTime'])}'),
              const SizedBox(height: 12),
              _buildDetailItem('Date', ctrl.formatSlotDate(slot['startTime'])),
              const SizedBox(height: 12),
              _buildDetailItem('Duration', _calculateDuration(slot['startTime'], slot['endTime'])),
              const SizedBox(height: 12),
              _buildDetailItem('Type', isRecurring ? 'Recurring (Weekly)' : 'One-time'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.close(1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Close', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppTheme.backgroundLight, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _showFiltersDialog() {
    DateTime? startDate = ctrl.startDate.value;
    DateTime? endDate = ctrl.endDate.value;
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
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
                    child: Icon(Icons.filter_alt_rounded, color: AppTheme.primaryBlue, size: 40),
                  ),
                  const SizedBox(height: 16),
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
                          onPressed: () => Get.close(1),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.textSecondary,
                            side: BorderSide(color: AppTheme.borderColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ctrl.applySlotsFilters(start: startDate, end: endDate);
                            Get.close(1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Apply Filters', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
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
    var startTime = TimeOfDay.now();
    var endTime = TimeOfDay(hour: startTime.hour + 1, minute: startTime.minute);
    DateTime selectedDate = DateTime.now();
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
                  _buildDatePicker('Date', selectedDate, (date) => setState(() => selectedDate = date)),
                  const SizedBox(height: 16),
                  _buildTimePicker('Start Time', startTime, (time) => setState(() => startTime = time)),
                  const SizedBox(height: 16),
                  _buildTimePicker('End Time', endTime, (time) => setState(() => endTime = time)),
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
                          onPressed: () => Get.close(1),
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
                            Get.close(1);
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
                      onPressed: () => Get.close(1),
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
                        Get.close(1);
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

  Widget _buildDatePicker(String label, DateTime date, Function(DateTime) onDateChanged) {
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
            final DateTime now = DateTime.now();
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: now,
              lastDate: DateTime(now.year + 1, now.month, now.day),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: AppTheme.primaryBlue,
                    colorScheme: ColorScheme.light(primary: AppTheme.primaryBlue),
                    buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              onDateChanged(picked);
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
                  DateFormat('MMM dd, yyyy').format(date),
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
