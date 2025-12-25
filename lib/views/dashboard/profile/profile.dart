import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/models/user_model.dart';
import 'package:prime_health_doctors/utils/decoration.dart';
import 'package:prime_health_doctors/utils/network/api_config.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/auth/register/ui/service_selection_ui.dart';
import 'package:prime_health_doctors/views/dashboard/profile/profile_ctrl.dart';
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
                      if (ctrl.isEditMode)
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            padding: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: Icon(Icons.save_rounded, color: Colors.white, size: 20),
                          onPressed: ctrl.saveProfile,
                        ),
                      if (!ctrl.isEditMode)
                        IconButton(
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            padding: WidgetStatePropertyAll(const EdgeInsets.all(8)),
                            backgroundColor: WidgetStatePropertyAll(Colors.grey[100]),
                          ),
                          icon: Icon(Icons.settings_outlined, color: decoration.colorScheme.primary, size: 20),
                          onPressed: () => Get.to(() => const Settings()),
                          tooltip: 'Settings',
                        ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: AppTheme.backgroundLight,
                            padding: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: Icon(ctrl.isEditMode ? Icons.close_rounded : Icons.edit_rounded, color: ctrl.isEditMode ? AppTheme.emergencyRed : AppTheme.primaryBlue, size: 20),
                          onPressed: ctrl.toggleEditMode,
                          tooltip: ctrl.isEditMode ? 'Cancel Edit' : 'Edit Profile',
                        ),
                      ),
                    ],
                  ),
                  if (ctrl.isLoading.value) SliverToBoxAdapter(child: LinearProgressIndicator()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildProfileHeader(ctrl),
                          const SizedBox(height: 24),
                          _buildPersonalInfoSection(ctrl, context),
                          const SizedBox(height: 24),
                          _buildProfessionalInfoSection(ctrl),
                          const SizedBox(height: 24),
                          _buildPricingSection(ctrl),
                          if (ctrl.isEditMode || ctrl.user.value.certifications.isNotEmpty) ...[const SizedBox(height: 24), _buildCertificationsSection(ctrl, context)],
                          if (ctrl.isEditMode) ...[const SizedBox(height: 24), _buildLogoSection(ctrl)],
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: !ctrl.isEditMode ? null : () => ctrl.pickAvatar(),
            child: Stack(
              children: [
                Obx(() {
                  final hasProfileImage = ctrl.user.value.profileImage.isNotEmpty;
                  final hasAvatar = ctrl.avatar.value != null;
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                      image: hasAvatar
                          ? DecorationImage(image: FileImage(ctrl.avatar.value!), fit: BoxFit.cover)
                          : (hasProfileImage ? DecorationImage(image: NetworkImage(APIConfig.resourceBaseURL + ctrl.user.value.profileImage), fit: BoxFit.cover) : null),
                    ),
                    child: !hasProfileImage && !hasAvatar ? Icon(Icons.person_rounded, size: 40, color: Colors.white) : null,
                  );
                }),
                if (ctrl.isEditMode)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(Icons.camera_alt_rounded, size: 16, color: AppTheme.primaryBlue),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ctrl.isEditMode)
                  _buildEditTextField(ctrl.nameController, 'Full Name')
                else
                  Obx(
                    () => Text(
                      ctrl.user.value.name,
                      style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 6),
                if (ctrl.isEditMode)
                  _buildEditTextField(ctrl.emailController, 'Email Address', isEmail: true)
                else
                  Obx(() => Text(ctrl.user.value.email, style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withOpacity(0.9)))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(ProfileCtrl ctrl, BuildContext context) {
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
          if (ctrl.isEditMode) ...[
            _buildEditField('Full Name', ctrl.nameController, Icons.person_2_rounded),
            _buildEditField('Email Address', ctrl.emailController, Icons.email_rounded, isEmail: true),
            _buildEditField('Mobile Number', ctrl.mobileController, Icons.phone_rounded, isPhone: true),
            _buildEditField('License Number', ctrl.licenseController, Icons.badge_rounded),
            _buildServiceField(ctrl, context),
            _buildSpecialtyField(ctrl, context),
          ] else ...[
            _buildInfoTile(Icons.phone_rounded, 'Mobile', ctrl.user.value.mobile),
            _buildInfoTile(Icons.badge_rounded, 'License', ctrl.user.value.license),
            _buildInfoTile(Icons.work_rounded, 'Service', ctrl.selectedServiceName.value),
            _buildInfoTile(Icons.medical_services_rounded, 'Specialty', ctrl.selectedSpecialtyName.value),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceField(ProfileCtrl ctrl, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.work_rounded, color: AppTheme.primaryBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Service',
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Obx(() {
                  return ctrl.isServicesLoading.value ? _buildLoadingField('Loading services...') : _buildServiceDropdown(context, ctrl);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDropdown(BuildContext context, ProfileCtrl ctrl) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: ctrl.selectedServiceName.value),
      onTap: () => _showServiceSelection(context, ctrl),
      decoration: InputDecoration(
        hintText: 'Select your medical service',
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppTheme.textLight, fontWeight: FontWeight.w400),
        suffixIcon: Icon(Icons.arrow_drop_down_rounded, color: AppTheme.textSecondary, size: 22),
        filled: true,
        fillColor: AppTheme.backgroundWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildSpecialtyField(ProfileCtrl ctrl, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.medical_services_rounded, color: AppTheme.primaryBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Specialty',
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Obx(() {
                  if (ctrl.selectedService.value.isEmpty) {
                    return _buildInfoField('Please select a service first');
                  }
                  return ctrl.isSpecialtyLoading.value ? _buildLoadingField('Loading specialities...') : _buildSpecialtyDropdown(context, ctrl);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppTheme.textLight, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtyDropdown(BuildContext context, ProfileCtrl ctrl) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: ctrl.selectedSpecialtyName.value),
      onTap: () => _showSpecialtySelection(context, ctrl),
      decoration: InputDecoration(
        hintText: 'Select your medical specialty',
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppTheme.textLight, fontWeight: FontWeight.w400),
        suffixIcon: Icon(Icons.arrow_drop_down_rounded, color: AppTheme.textSecondary, size: 22),
        filled: true,
        fillColor: AppTheme.backgroundWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildLoadingField(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          const SizedBox(width: 12),
          Text(text, style: GoogleFonts.inter(color: AppTheme.textLight)),
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
          if (ctrl.isEditMode)
            _buildEditField('Bio', ctrl.bioController, Icons.description_rounded, maxLines: 3)
          else if (ctrl.user.value.bio.isNotEmpty)
            _buildInfoTile(Icons.description_rounded, 'Bio', ctrl.user.value.bio)
          else
            _buildEmptyState('No bio added yet', Icons.info_outline_rounded),
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
          if (ctrl.isEditMode)
            _buildPricingEditField(ctrl)
          else
            Column(
              children: [
                _buildInfoTile(Icons.money_rounded, 'Consultation Fee', '₹${ctrl.user.value.pricing.consultationFee}'),
                _buildInfoTile(Icons.currency_rupee_rounded, 'Follow-up Fee', '₹${ctrl.user.value.pricing.followUpFee}'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPricingEditField(ProfileCtrl ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consultation Fee',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: ctrl.consultationFeeController,
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: '500',
                    hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
                    prefixIcon: Icon(Icons.currency_rupee_rounded, color: AppTheme.textSecondary, size: 18),
                    filled: true,
                    fillColor: AppTheme.backgroundWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.primaryBlue, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Follow-up Fee',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: ctrl.followUpFeeController,
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: '300',
                    hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
                    prefixIcon: Icon(Icons.currency_rupee_rounded, color: AppTheme.textSecondary, size: 18),
                    filled: true,
                    fillColor: AppTheme.backgroundWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.primaryBlue, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationsSection(ProfileCtrl ctrl, BuildContext context) {
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
                if (ctrl.isEditMode) ...[
                  const Spacer(),
                  IconButton(
                    onPressed: ctrl.addCertification,
                    icon: Icon(Icons.add_circle_rounded, color: AppTheme.primaryBlue, size: 20),
                    tooltip: 'Add Certification',
                  ),
                ],
              ],
            ),
          ),
          if (ctrl.isEditMode)
            _buildCertificationsEditField(ctrl, context)
          else if (ctrl.user.value.certifications.isNotEmpty)
            ...ctrl.user.value.certifications.map((cert) => _buildCertificationTile(cert))
          else
            _buildEmptyState('No certifications added yet', Icons.workspace_premium_outlined),
        ],
      ),
    );
  }

  Widget _buildCertificationsEditField(ProfileCtrl ctrl, BuildContext context) {
    return Obx(() {
      if (ctrl.certifications.isEmpty) {
        return _buildNoCertificationsPlaceholder(ctrl);
      }
      return Column(
        children: [
          ...ctrl.certifications.asMap().entries.map((entry) {
            final index = entry.key;
            final certification = entry.value;
            return _buildCertificationEditItem(ctrl, context, index, certification);
          }),
        ],
      );
    });
  }

  Widget _buildCertificationEditItem(ProfileCtrl ctrl, BuildContext context, int index, Map<String, dynamic> certification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Certification ${index + 1}',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => ctrl.removeCertification(index),
                icon: Icon(Icons.delete_rounded, color: Colors.red, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: certification['name'],
            onChanged: (value) => ctrl.updateCertification(index, 'name', value),
            decoration: InputDecoration(
              labelText: 'Certification Name',
              labelStyle: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
              hintText: 'e.g., MBBS, MD, Board Certification',
              hintStyle: GoogleFonts.inter(color: AppTheme.textLight),
              filled: true,
              fillColor: AppTheme.backgroundWhite,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.primaryBlue, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: certification['issuedBy'],
            onChanged: (value) => ctrl.updateCertification(index, 'issuedBy', value),
            decoration: InputDecoration(
              labelText: 'Issuing Authority',
              labelStyle: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
              hintText: 'e.g., Medical Council, University',
              hintStyle: GoogleFonts.inter(color: AppTheme.textLight),
              filled: true,
              fillColor: AppTheme.backgroundWhite,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.primaryBlue, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: certification['issueDate'],
            onChanged: (value) => ctrl.updateCertification(index, 'issueDate', value),
            decoration: InputDecoration(
              labelText: 'Issue Date',
              labelStyle: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
              hintText: 'YYYY-MM-DD',
              hintStyle: GoogleFonts.inter(color: AppTheme.textLight),
              filled: true,
              fillColor: AppTheme.backgroundWhite,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.primaryBlue, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          _buildDocumentUploadField(ctrl, index, certification),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadField(ProfileCtrl ctrl, int index, Map<String, dynamic> certification) {
    final hasDocument = certification['document']?.isNotEmpty == true;
    final hasFile = ctrl.certificationDocuments[index] != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Document',
          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => ctrl.pickCertificationDocument(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.attach_file_rounded, color: AppTheme.primaryBlue, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hasFile ? ctrl.certificationDocuments[index]!.path.split('/').last : (hasDocument ? 'Document attached' : 'Upload certification document'),
                    style: GoogleFonts.inter(fontSize: 14, color: hasFile || hasDocument ? AppTheme.textPrimary : AppTheme.textLight),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasFile || hasDocument) Icon(Icons.check_circle_rounded, color: AppTheme.accentGreen, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoSection(ProfileCtrl ctrl) {
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
                Icon(Icons.business_rounded, color: AppTheme.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Clinic Logo',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: GestureDetector(
              onTap: ctrl.pickLogo,
              child: Obx(() {
                final hasLogo = ctrl.user.value.logo.isNotEmpty;
                final hasLogoFile = ctrl.logo.value != null;
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderColor, style: BorderStyle.solid),
                    image: hasLogoFile
                        ? DecorationImage(image: FileImage(ctrl.logo.value!), fit: BoxFit.cover)
                        : (hasLogo ? DecorationImage(image: NetworkImage(APIConfig.resourceBaseURL + ctrl.user.value.logo), fit: BoxFit.cover) : null),
                  ),
                  child: !hasLogo && !hasLogoFile
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_rounded, size: 32, color: AppTheme.textLight),
                            const SizedBox(height: 8),
                            Text('Add Logo', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textLight)),
                          ],
                        )
                      : null,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationTile(Certification cert) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(Icons.attach_file_rounded, size: 14, color: AppTheme.primaryBlue),
                        const SizedBox(width: 4),
                        Text('View Document', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.primaryBlue)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCertificationsPlaceholder(ProfileCtrl ctrl) {
    return GestureDetector(
      onTap: ctrl.addCertification,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor, style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Icons.add_circle_outline_rounded, color: AppTheme.textLight, size: 32),
            const SizedBox(height: 8),
            Text(
              'Add Your First Certification',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 4),
            Text('Tap to add medical certifications', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textLight)),
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
                  value,
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, IconData icon, {bool isPhone = false, bool isEmail = false, int maxLines = 1, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                TextField(
                  controller: controller,
                  readOnly: readOnly,
                  keyboardType: isPhone
                      ? TextInputType.phone
                      : isEmail
                      ? TextInputType.emailAddress
                      : TextInputType.text,
                  maxLines: maxLines,
                  textInputAction: TextInputAction.done,
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditTextField(TextEditingController controller, String hintText, {bool isEmail = false}) {
    return TextField(
      readOnly: true,
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: Colors.black.withOpacity(0.7), fontSize: 14),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        isDense: true,
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor, style: BorderStyle.solid),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.textLight),
            const SizedBox(width: 12),
            Text(message, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }

  void _showServiceSelection(BuildContext context, ProfileCtrl ctrl) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: ServiceSelectionUI(
          title: 'Select Medical Service',
          items: ctrl.services,
          selectedItems: {"_id": ctrl.selectedService.value, "name": ctrl.selectedServiceName.value},
          onSelectionChanged: ctrl.setSelectedService,
          itemType: 'service',
        ),
      ),
    );
  }

  void _showSpecialtySelection(BuildContext context, ProfileCtrl ctrl) {
    ctrl.loadSpecialities();
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: ServiceSelectionUI(
          title: 'Select Medical Specialty',
          items: ctrl.specialities,
          selectedItems: {"_id": ctrl.selectedSpecialty.value, "name": ctrl.selectedSpecialtyName.value},
          onSelectionChanged: ctrl.setSelectedSpecialty,
          itemType: 'specialties',
        ),
      ),
    );
  }
}
