import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/utils/decoration.dart';
import 'package:prime_health_doctors/utils/network/api_config.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/auth/register/ui/service_selection_ui.dart';
import 'package:prime_health_doctors/views/dashboard/profile/profile_ctrl.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  final List<String> _stepTitles = ['Profile & Logo', 'Bio', 'Pricing', 'Certifications'];
  final List<IconData> _stepIcons = [Icons.person_rounded, Icons.description_rounded, Icons.attach_money_rounded, Icons.workspace_premium_rounded];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileCtrl>(
      init: ProfileCtrl(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.white,
                side: BorderSide(color: decoration.colorScheme.primary.withOpacity(.1)),
              ),
              icon: Icon(Icons.arrow_back_rounded, color: decoration.colorScheme.primary, size: 24),
              onPressed: () => Get.close(1),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profile',
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                Text(
                  'Step ${_currentStep + 1} of ${_stepTitles.length}',
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              _buildStepIndicator(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [_buildProfileStep(ctrl, context), _buildBioStep(ctrl), _buildPricingStep(ctrl), _buildCertificationsStep(ctrl, context)],
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(ctrl),
        );
      },
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_stepTitles.length, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() => _currentStep = index);
                  _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
                child: Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: isActive ? AppTheme.primaryBlue : (isCompleted ? AppTheme.accentGreen : Colors.grey.shade200), shape: BoxShape.circle),
                      child: Icon(_stepIcons[index], color: isActive || isCompleted ? Colors.white : Colors.grey.shade500, size: 18),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _stepTitles[index],
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isActive ? AppTheme.primaryBlue : (isCompleted ? AppTheme.accentGreen : AppTheme.textLight)),
                    ),
                  ],
                ),
              ),
              if (index < _stepTitles.length - 1)
                Container(width: 24, height: 2, margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4), color: isCompleted ? AppTheme.accentGreen : Colors.grey.shade300),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProfileStep(ProfileCtrl ctrl, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSectionCard(
            title: 'Profile Photo',
            icon: Icons.person_rounded,
            child: Center(
              child: GestureDetector(
                onTap: () => ctrl.pickAvatar(),
                child: Stack(
                  children: [
                    Obx(() {
                      final hasProfileImage = ctrl.user.value.profileImage.isNotEmpty;
                      final hasAvatar = ctrl.avatar.value != null;
                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundLight,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3), width: 3),
                          image: hasAvatar
                              ? DecorationImage(image: FileImage(ctrl.avatar.value!), fit: BoxFit.cover)
                              : (hasProfileImage ? DecorationImage(image: NetworkImage(APIConfig.resourceBaseURL + ctrl.user.value.profileImage), fit: BoxFit.cover) : null),
                        ),
                        child: !hasProfileImage && !hasAvatar ? Icon(Icons.person_rounded, size: 50, color: AppTheme.primaryBlue.withOpacity(0.5)) : null,
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                        child: Icon(Icons.camera_alt_rounded, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Clinic Logo',
            icon: Icons.business_rounded,
            child: Center(
              child: InkWell(
                onTap: ctrl.pickLogo,
                borderRadius: BorderRadius.circular(16),
                child: Obx(() {
                  final hasLogo = ctrl.user.value.logo.isNotEmpty;
                  final hasLogoFile = ctrl.logo.value != null;
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3), width: 2),
                      image: hasLogoFile
                          ? DecorationImage(image: FileImage(ctrl.logo.value!), fit: BoxFit.cover)
                          : (hasLogo ? DecorationImage(image: NetworkImage(APIConfig.resourceBaseURL + ctrl.user.value.logo), fit: BoxFit.cover) : null),
                    ),
                    child: !hasLogo && !hasLogoFile
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_rounded, size: 32, color: AppTheme.primaryBlue.withOpacity(0.5)),
                              const SizedBox(height: 8),
                              Text(
                                'Add Logo',
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                                  ),
                                  child: Icon(Icons.edit_rounded, size: 12, color: AppTheme.primaryBlue),
                                ),
                              ),
                            ],
                          ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Personal Information',
            icon: Icons.info_outline_rounded,
            child: Column(
              children: [
                _buildEditField('Full Name', ctrl.nameController, Icons.person_rounded),
                const SizedBox(height: 12),
                _buildEditField('Email Address', ctrl.emailController, Icons.email_rounded, readOnly: true),
                const SizedBox(height: 12),
                _buildEditField('Mobile Number', ctrl.mobileController, Icons.phone_rounded, isPhone: true),
                const SizedBox(height: 12),
                _buildEditField('License Number', ctrl.licenseController, Icons.badge_rounded),
                const SizedBox(height: 12),
                _buildServiceField(ctrl, context),
                const SizedBox(height: 12),
                _buildSpecialtyField(ctrl, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioStep(ProfileCtrl ctrl) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _buildSectionCard(
        title: 'Professional Bio',
        icon: Icons.description_rounded,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tell patients about your qualifications, experience, and areas of expertise', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl.bioController,
              maxLines: 8,
              textInputAction: TextInputAction.done,
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Example: I am a board-certified physician with 10+ years of experience in...',
                hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingStep(ProfileCtrl ctrl) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _buildSectionCard(
        title: 'Consultation Pricing',
        icon: Icons.attach_money_rounded,
        child: Column(
          children: [
            Text('Set your consultation fees. These will be displayed to patients.', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
            const SizedBox(height: 20),
            _buildPriceEditField('Consultation Fee', ctrl.consultationFeeController, AppTheme.primaryBlue),
            const SizedBox(height: 16),
            _buildPriceEditField('Follow-up Fee', ctrl.followUpFeeController, AppTheme.accentGreen),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationsStep(ProfileCtrl ctrl, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _buildSectionCard(
        title: 'Certifications',
        icon: Icons.workspace_premium_rounded,
        trailing: IconButton(
          onPressed: ctrl.addCertification,
          icon: Icon(Icons.add_circle_rounded, color: AppTheme.primaryBlue, size: 24),
          tooltip: 'Add Certification',
        ),
        child: Obx(() {
          if (ctrl.certifications.isEmpty) {
            return _buildNoCertificationsPlaceholder(ctrl);
          }
          return Column(
            children: ctrl.certifications.asMap().entries.map((entry) {
              final index = entry.key;
              final certification = entry.value;
              return _buildCertificationEditItem(ctrl, context, index, certification);
            }).toList(),
          );
        }),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child, Widget? trailing}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20), child: child),
        ],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, IconData icon, {bool isPhone = false, bool isEmail = false, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          textInputAction: TextInputAction.done,
          keyboardType: isPhone ? TextInputType.phone : (isEmail ? TextInputType.emailAddress : TextInputType.text),
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: readOnly ? AppTheme.textSecondary : AppTheme.textPrimary),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
            suffixIcon: readOnly ? Icon(Icons.lock_outline, color: AppTheme.textLight, size: 16) : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceField(ProfileCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medical Service *',
          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Obx(() => ctrl.isServicesLoading.value ? _buildLoadingField('Loading services...') : _buildServiceDropdown(context, ctrl)),
      ],
    );
  }

  Widget _buildServiceDropdown(BuildContext context, ProfileCtrl ctrl) {
    return InkWell(
      onTap: () => _showServiceSelection(context, ctrl),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.work_rounded, color: AppTheme.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                ctrl.selectedServiceName.value.isNotEmpty ? ctrl.selectedServiceName.value : 'Select medical service',
                style: GoogleFonts.inter(fontSize: 14, color: ctrl.selectedServiceName.value.isNotEmpty ? AppTheme.textPrimary : AppTheme.textLight, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_drop_down_rounded, color: AppTheme.textSecondary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialtyField(ProfileCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medical Specialty *',
          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (ctrl.selectedService.value.isEmpty) {
            return _buildInfoField('Please select a service first');
          }
          return ctrl.isSpecialtyLoading.value ? _buildLoadingField('Loading specialities...') : _buildSpecialtyDropdown(context, ctrl);
        }),
      ],
    );
  }

  Widget _buildSpecialtyDropdown(BuildContext context, ProfileCtrl ctrl) {
    return InkWell(
      onTap: () => _showSpecialtySelection(context, ctrl),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.medical_services_rounded, color: AppTheme.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                ctrl.selectedSpecialtyName.value.isNotEmpty ? ctrl.selectedSpecialtyName.value : 'Select medical specialty',
                style: GoogleFonts.inter(fontSize: 14, color: ctrl.selectedSpecialtyName.value.isNotEmpty ? AppTheme.textPrimary : AppTheme.textLight, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_drop_down_rounded, color: AppTheme.textSecondary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: Colors.amber.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: GoogleFonts.inter(fontSize: 13, color: Colors.amber.shade800)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingField(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor, width: 1.5),
      ),
      child: Row(
        children: [
          SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryBlue)),
          const SizedBox(width: 12),
          Text(text, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildPriceEditField(String label, TextEditingController controller, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '₹',
                style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  cursorHeight: 28,
                  cursorRadius: Radius.circular(10.0),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: color),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: GoogleFonts.inter(color: color.withOpacity(0.3)),
                    isDense: true,
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('per session', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textLight)),
        ],
      ),
    );
  }

  Widget _buildCertificationEditItem(ProfileCtrl ctrl, BuildContext context, int index, Map<String, dynamic> certification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.workspace_premium_rounded, color: Colors.amber.shade700, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                'Certification ${index + 1}',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => ctrl.removeCertification(index),
                icon: Icon(Icons.delete_rounded, color: Colors.red.shade400, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCertificationTextField('Certification Name', certification['name'], (value) => ctrl.updateCertification(index, 'name', value), 'e.g., MBBS, MD'),
          const SizedBox(height: 10),
          _buildCertificationTextField('Issuing Authority', certification['issuedBy'], (value) => ctrl.updateCertification(index, 'issuedBy', value), 'e.g., Medical Council'),
          const SizedBox(height: 10),
          _buildCertificationTextField('Issue Date', certification['issueDate'], (value) => ctrl.updateCertification(index, 'issueDate', value), 'YYYY-MM-DD'),
          const SizedBox(height: 10),
          _buildDocumentUploadField(ctrl, index, certification),
        ],
      ),
    );
  }

  Widget _buildCertificationTextField(String label, String initialValue, Function(String) onChanged, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.primaryBlue, width: 1.5),
            ),
          ),
        ),
      ],
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
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => ctrl.pickCertificationDocument(index),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.attach_file_rounded, color: AppTheme.primaryBlue, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hasFile ? ctrl.certificationDocuments[index]!.path.split('/').last : (hasDocument ? 'Document attached' : 'Upload document'),
                    style: GoogleFonts.inter(fontSize: 13, color: hasFile || hasDocument ? AppTheme.textPrimary : AppTheme.textLight, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasFile || hasDocument) Icon(Icons.check_circle_rounded, color: AppTheme.accentGreen, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoCertificationsPlaceholder(ProfileCtrl ctrl) {
    return InkWell(
      onTap: ctrl.addCertification,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(Icons.add_circle_outline_rounded, color: AppTheme.primaryBlue.withOpacity(0.5), size: 40),
            const SizedBox(height: 12),
            Text(
              'Add Your First Certification',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 4),
            Text('Tap to add certifications', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(ProfileCtrl ctrl) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _currentStep--);
                    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primaryBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Back',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentStep < _stepTitles.length - 1) {
                    setState(() => _currentStep++);
                    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  } else {
                    ctrl.saveProfile();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentStep == _stepTitles.length - 1 ? AppTheme.accentGreen : AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_currentStep == _stepTitles.length - 1 ? Icons.check_rounded : Icons.arrow_forward_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(_currentStep == _stepTitles.length - 1 ? 'Save Profile' : 'Continue', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
              ),
            ),
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
