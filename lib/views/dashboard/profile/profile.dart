import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/models/user_model.dart';
import 'package:prime_health_doctors/utils/network/api_config.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/dashboard/profile/profile_ctrl.dart';
import 'package:prime_health_doctors/views/dashboard/profile/ui/edit_profile.dart';
import 'package:prime_health_doctors/views/dashboard/profile/ui/settings_ui.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileCtrl>(
      init: ProfileCtrl(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          body: RefreshIndicator(
            onRefresh: () async => await ctrl.loadUserData(),
            child: Obx(() {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    elevation: 0,
                    backgroundColor: AppTheme.backgroundWhite,
                    pinned: true,
                    floating: true,
                    automaticallyImplyLeading: false,
                    title: Text(
                      'My Profile',
                      style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                    actions: [
                      IconButton(
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: AppTheme.primaryBlue.withOpacity(.1)),
                        ),
                        icon: Icon(Icons.settings_outlined, color: AppTheme.primaryBlue, size: 20),
                        onPressed: () => Get.to(() => const Settings()),
                        tooltip: 'Settings',
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: AppTheme.primaryBlue.withOpacity(.1)),
                        ),
                        icon: Icon(Icons.edit_rounded, color: AppTheme.primaryBlue, size: 20),
                        onPressed: () => Get.to(() => const EditProfile()),
                        tooltip: 'Edit Profile',
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  if (ctrl.isLoading.value) const SliverToBoxAdapter(child: LinearProgressIndicator()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: Get.height * .1),
                      child: Column(
                        children: [
                          _buildProfileHeader(ctrl),
                          const SizedBox(height: 24),
                          _buildPersonalInfoSection(ctrl),
                          const SizedBox(height: 24),
                          _buildProfessionalInfoSection(ctrl),
                          const SizedBox(height: 24),
                          _buildPricingSection(ctrl),
                          if (ctrl.user.value.certifications.isNotEmpty) ...[const SizedBox(height: 24), _buildCertificationsSection(ctrl)],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(ProfileCtrl ctrl) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primaryBlue.withOpacity(0.9), AppTheme.accentTeal]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Obx(() {
            final hasProfileImage = ctrl.user.value.profileImage.isNotEmpty;
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                image: hasProfileImage ? DecorationImage(image: NetworkImage(APIConfig.resourceBaseURL + ctrl.user.value.profileImage), fit: BoxFit.cover) : null,
              ),
              child: !hasProfileImage ? Icon(Icons.person_rounded, size: 40, color: Colors.white) : null,
            );
          }),
          const SizedBox(height: 16),
          Obx(
            () => Text(
              ctrl.user.value.name,
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Obx(() => Text(ctrl.user.value.email, style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withOpacity(0.9)))),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(ProfileCtrl ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 6),
            child: Row(
              children: [
                Icon(Icons.person_outline_rounded, color: AppTheme.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Personal Information',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
          _buildInfoTile(Icons.phone_rounded, 'Mobile', ctrl.user.value.mobile),
          _buildInfoTile(Icons.badge_rounded, 'License', ctrl.user.value.license),
          _buildInfoTile(Icons.work_rounded, 'Service', ctrl.selectedServiceName.value),
          _buildInfoTile(Icons.medical_services_rounded, 'Specialty', ctrl.selectedSpecialtyName.value),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoSection(ProfileCtrl ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 6),
            child: Row(
              children: [
                Icon(Icons.description_rounded, color: AppTheme.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Professional Bio',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ctrl.user.value.bio.isNotEmpty
                ? Text(ctrl.user.value.bio, style: GoogleFonts.inter(fontSize: 15, color: AppTheme.textPrimary, height: 1.5))
                : _buildEmptyState('No bio added yet', Icons.info_outline_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(ProfileCtrl ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 6),
            child: Row(
              children: [
                Icon(Icons.attach_money_rounded, color: AppTheme.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Pricing',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _buildPriceTile('Consultation Fee', '₹${ctrl.user.value.pricing.consultationFee}', Icons.money_rounded),
              _buildPriceTile('Follow-up Fee', '₹${ctrl.user.value.pricing.followUpFee}', Icons.currency_rupee_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationsSection(ProfileCtrl ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 6),
            child: Row(
              children: [
                Icon(Icons.workspace_premium_rounded, color: AppTheme.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Certifications',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
                const Spacer(),
                Text(
                  '${ctrl.user.value.certifications.length}',
                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          ...ctrl.user.value.certifications.map((cert) => _buildCertificationTile(cert)),
        ],
      ),
    );
  }

  Widget _buildCertificationTile(Certification cert) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppTheme.backgroundLight, borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.verified_rounded, color: AppTheme.accentGreen, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cert.name,
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text('Issued by: ${cert.issuedBy}', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                  const SizedBox(height: 2),
                  Text('Date: ${cert.issueDate.day}/${cert.issueDate.month}/${cert.issueDate.year}', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textLight)),
                  if (cert.document.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.attach_file_rounded, size: 14, color: AppTheme.primaryBlue),
                            const SizedBox(width: 4),
                            Text(
                              'View Document',
                              style: GoogleFonts.inter(fontSize: 12, color: AppTheme.primaryBlue, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  value.isNotEmpty ? value : 'Not provided',
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppTheme.accentGreen, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor, style: BorderStyle.solid),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textLight),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
          ),
        ],
      ),
    );
  }
}
