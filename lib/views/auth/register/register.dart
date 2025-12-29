import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/auth/register/register_ctrl.dart';
import 'package:prime_health_doctors/views/auth/register/ui/service_selection_ui.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterCtrl>(
      init: RegisterCtrl(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundWhite,
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      _buildHeaderSection(context),
                      const SizedBox(height: 32),
                      _buildRegistrationForm(ctrl, context),
                      const SizedBox(height: 32),
                      _buildTermsAgreement(context),
                      const SizedBox(height: 24),
                      Obx(() => _buildRegisterButton(ctrl, context)),
                      const SizedBox(height: 24),
                      _buildLoginRedirect(context, ctrl),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                _buildBackButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primaryLight, AppTheme.primaryBlue]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
              image: DecorationImage(image: AssetImage("assets/fg_logo.png")),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Join PrimeHealth',
            style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, height: 1.2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your professional medical account',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: AppTheme.textSecondary, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Personal Information'),
        const SizedBox(height: 20),
        _buildNameField(ctrl, context),
        const SizedBox(height: 16),
        _buildEmailField(ctrl, context),
        const SizedBox(height: 16),
        _buildMobileField(ctrl, context),
        const SizedBox(height: 24),
        _buildSectionHeader('Professional Information'),
        const SizedBox(height: 16),
        _buildServicesField(ctrl, context),
        const SizedBox(height: 16),
        _buildSpecialtyField(ctrl, context),
        const SizedBox(height: 16),
        _buildLicenseField(ctrl, context),
        const SizedBox(height: 16),
        _buildBioField(ctrl, context),
        const SizedBox(height: 24),
        _buildSectionHeader('Pricing'),
        const SizedBox(height: 16),
        _buildPricingField(ctrl, context),
        const SizedBox(height: 24),
        _buildSectionHeader('Certifications'),
        const SizedBox(height: 16),
        _buildCertificationsField(ctrl, context),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
    );
  }

  Widget _buildNameField(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Doctor Name',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl.nameCtrl,
          textInputAction: TextInputAction.next,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
            prefixIcon: Icon(Icons.person_2_rounded, color: AppTheme.textSecondary, size: 22),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl.emailCtrl,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'doctor@primehealth.com',
            hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
            prefixIcon: Icon(Icons.email_rounded, color: AppTheme.textSecondary, size: 22),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileField(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl.mobileCtrl,
          keyboardType: TextInputType.numberWithOptions(signed: true),
          textInputAction: TextInputAction.next,
          maxLength: 10,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Enter 10-digit mobile number',
            hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
            prefixIcon: Icon(Icons.phone_rounded, color: AppTheme.textSecondary, size: 22),
            counterText: '',
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtyField(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medical Specialty',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
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

  Widget _buildSpecialtyDropdown(BuildContext context, RegisterCtrl ctrl) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: ctrl.selectedSpecialtyName.value),
      onTap: () => _showSelectionBottomSheet(
        context,
        ctrl,
        'Select Medical Specialty',
        ctrl.specialities,
        ctrl.selectedSpecialty.value.isNotEmpty ? {"_id": ctrl.selectedSpecialty.value, "name": ctrl.selectedSpecialtyName.value} : null,
        ctrl.setSelectedSpecialty,
        'specialty',
      ),
      decoration: InputDecoration(
        hintText: 'Select your medical specialty',
        hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
        prefixIcon: Icon(Icons.medical_services_rounded, color: AppTheme.textSecondary, size: 22),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildServicesField(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medical Services',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return ctrl.isServicesLoading.value ? _buildLoadingField('Loading services...') : _buildServicesDropdown(context, ctrl);
        }),
      ],
    );
  }

  Widget _buildServicesDropdown(BuildContext context, RegisterCtrl ctrl) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: ctrl.selectedServiceName.value),
      onTap: () => _showSelectionBottomSheet(
        context,
        ctrl,
        'Select Medical Service',
        ctrl.services,
        ctrl.selectedService.value.isNotEmpty ? {"_id": ctrl.selectedService.value, "name": ctrl.selectedServiceName.value} : null,
        ctrl.setSelectedService,
        'service',
      ),
      decoration: InputDecoration(
        hintText: 'Select your medical service',
        hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
        prefixIcon: Icon(Icons.work_rounded, color: AppTheme.textSecondary, size: 22),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

  Widget _buildLicenseField(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medical License Number',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl.licenseCtrl,
          textInputAction: TextInputAction.next,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Enter your medical license number',
            hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
            prefixIcon: Icon(Icons.badge_rounded, color: AppTheme.textSecondary, size: 22),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildBioField(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Professional Bio',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl.bioCtrl,
          maxLines: 3,
          textInputAction: TextInputAction.next,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Brief about your professional experience...',
            hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
            alignLabelWithHint: true,
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingField(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pricing',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        Row(
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
                    controller: ctrl.consultationFeeCtrl,
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
                    controller: ctrl.followUpFeeCtrl,
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
      ],
    );
  }

  Widget _buildCertificationsField(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Certifications',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),
            const Spacer(),
            IconButton(
              onPressed: ctrl.addCertification,
              icon: Icon(Icons.add_circle_rounded, color: AppTheme.primaryBlue, size: 20),
              tooltip: 'Add Certification',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (ctrl.certifications.isEmpty) {
            return _buildNoCertificationsPlaceholder(ctrl);
          }
          return Column(
            children: [
              ...ctrl.certifications.asMap().entries.map((entry) {
                final index = entry.key;
                final certification = entry.value;
                return _buildCertificationItem(ctrl, context, index, certification);
              }),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildNoCertificationsPlaceholder(RegisterCtrl ctrl) {
    return GestureDetector(
      onTap: ctrl.addCertification,
      child: Container(
        width: double.infinity,
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

  Widget _buildCertificationItem(RegisterCtrl ctrl, BuildContext context, int index, Map<String, String> certification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        ],
      ),
    );
  }

  Widget _buildTermsAgreement(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.security_rounded, size: 20, color: AppTheme.primaryBlue),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: AppTheme.textSecondary, height: 1.4),
                children: [
                  const TextSpan(text: 'By creating an account, you agree to our '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(text: '. Your medical data is protected with end-to-end encryption.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(RegisterCtrl ctrl, BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: ctrl.isLoading.value ? null : ctrl.register,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: ctrl.isLoading.value
            ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8))))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_add_alt_1_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Create Professional Account',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLoginRedirect(BuildContext context, RegisterCtrl ctrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppTheme.textSecondary),
        ),
        GestureDetector(
          onTap: ctrl.goToLogin,
          child: Text(
            'Sign In',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      child: IconButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Color(0xFFF3F4F6)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF374151), size: 20),
        onPressed: () => Get.close(1),
      ),
    );
  }

  void _showSelectionBottomSheet(BuildContext context, RegisterCtrl ctrl, String title, List<dynamic> items, dynamic selectedItem, Function(dynamic) onSelectionChanged, String type) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: ServiceSelectionUI(title: title, items: items, selectedItems: selectedItem, onSelectionChanged: onSelectionChanged, itemType: type),
      ),
    );
  }
}
