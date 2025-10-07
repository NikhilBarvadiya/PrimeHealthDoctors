import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/models/service_model.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/dashboard/services/services_ctrl.dart';
import 'package:prime_health_doctors/views/dashboard/services/ui/service_details.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServicesCtrl>(
      init: ServicesCtrl(),
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
                      'Medical Services',
                      style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text('${ctrl.filteredServices.length} specialized services', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary))),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.backgroundLight,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: Icon(Icons.refresh_rounded, color: AppTheme.primaryBlue, size: 22),
                      onPressed: () => ctrl.filterServices(),
                      tooltip: 'Refresh Services',
                    ),
                  ),
                ],
                bottom: PreferredSize(preferredSize: const Size.fromHeight(70), child: _buildSearchSection(ctrl)),
              ),
              Obx(
                () => ctrl.filteredServices.isEmpty
                    ? SliverFillRemaining(child: _buildEmptyState(ctrl))
                    : SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final service = ctrl.filteredServices[index];
                            return _buildServiceCard(context, service, ctrl);
                          }, childCount: ctrl.filteredServices.length),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchSection(ServicesCtrl ctrl) {
    final TextEditingController searchController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search medical services...',
            hintStyle: GoogleFonts.inter(color: AppTheme.textLight),
            prefixIcon: Icon(Icons.search_rounded, color: AppTheme.textSecondary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear_rounded, color: AppTheme.textLight),
                    onPressed: () {
                      searchController.clear();
                      ctrl.searchServices('');
                    },
                  )
                : null,
          ),
          onChanged: (value) => ctrl.searchServices(value),
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, ServiceModel service, ServicesCtrl ctrl) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.to(() => ServiceDetails(service: service)),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppTheme.primaryLight.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                      child: Icon(service.icon, color: AppTheme.primaryLight, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          _buildRateDisplay(service.rate, service.id, ctrl),
                        ],
                      ),
                    ),
                    _buildStatusIndicator(service.isActive),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          service.description,
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600], height: 1.4),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).paddingOnly(left: 12),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: service.isActive,
                          activeColor: AppTheme.primaryLight,
                          inactiveTrackColor: Colors.grey[400],
                          onChanged: (value) => ctrl.toggleServiceStatus(service.id, value),
                        ),
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

  Widget _buildRateDisplay(double rate, int serviceId, ServicesCtrl ctrl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.currency_rupee, size: 12, color: Colors.blue[700]),
          Text(
            '${rate.toStringAsFixed(0)}/Budget',
            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.blue[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: isActive ? AppTheme.accentGreen.withOpacity(0.1) : AppTheme.emergencyRed.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: isActive ? AppTheme.accentGreen : AppTheme.emergencyRed, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: isActive ? AppTheme.accentGreen : AppTheme.emergencyRed),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ServicesCtrl ctrl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.medical_services_outlined, size: 80, color: AppTheme.textLight.withOpacity(0.5)),
        const SizedBox(height: 20),
        Text(
          'No Services Found',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Try adjusting your search or check back later for new medical services',
            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textLight),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => ctrl.searchServices(''),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            'View All Services',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
