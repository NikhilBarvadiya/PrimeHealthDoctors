import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/models/service_model.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/auth/register/register_ctrl.dart';
import 'package:prime_health_doctors/views/auth/register/ui/multi_selection_bottom_sheet.dart';

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
            ),
            child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 40),
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
        _buildEmailField(ctrl, context),
        const SizedBox(height: 16),
        _buildPasswordField(ctrl, context),
        const SizedBox(height: 16),
        _buildMobileField(ctrl, context),
        const SizedBox(height: 24),
        _buildSectionHeader('Professional Information'),
        const SizedBox(height: 20),
        _buildClinicField(ctrl, context),
        const SizedBox(height: 16),
        _buildSpecialtyField(ctrl, context),
        const SizedBox(height: 24),
        _buildSectionHeader('Services & Referrals'),
        const SizedBox(height: 20),
        _buildServicesField(ctrl, context),
        const SizedBox(height: 16),
        _buildReferralCodeField(ctrl, context),
        Obx(() {
          if (ctrl.selectedServices.isNotEmpty) {
            return Column(children: [const SizedBox(height: 16), _buildSelectedServicesPreview(ctrl)]);
          }
          return const SizedBox();
        }),
      ],
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
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

  Widget _buildPasswordField(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return TextFormField(
            controller: ctrl.passwordCtrl,
            obscureText: !ctrl.isPasswordVisible.value,
            textInputAction: TextInputAction.next,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'Create a strong password',
              hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
              prefixIcon: Icon(Icons.lock_rounded, color: AppTheme.textSecondary, size: 22),
              suffixIcon: IconButton(
                onPressed: ctrl.togglePasswordVisibility,
                icon: Icon(ctrl.isPasswordVisible.value ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: AppTheme.textSecondary, size: 22),
              ),
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
        }),
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
          keyboardType: TextInputType.phone,
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

  Widget _buildClinicField(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clinic/Hospital Name',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl.clinicCtrl,
          textInputAction: TextInputAction.next,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Enter your clinic or hospital name',
            hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
            prefixIcon: Icon(Icons.business_rounded, color: AppTheme.textSecondary, size: 22),
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
        TextFormField(
          controller: ctrl.specialtyCtrl,
          textInputAction: TextInputAction.next,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'e.g., Orthopedics, Neurology, Cardiology',
            hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
            prefixIcon: Icon(Icons.medical_services_rounded, color: AppTheme.textSecondary, size: 22),
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

  Widget _buildServicesField(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services Offered',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        _buildEnhancedMultiSelectField(
          context: context,
          items: ctrl.services,
          selectedItems: ctrl.selectedServices,
          hint: 'Select services you offer',
          icon: Icons.medical_services_rounded,
          onTap: () => _showServicesSelection(context, ctrl),
        ),
      ],
    );
  }

  Widget _buildReferralCodeField(RegisterCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Referral Code',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppTheme.accentGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(
                'Optional',
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: AppTheme.accentGreen),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl.referralCodeCtrl,
          textInputAction: TextInputAction.done,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
          onChanged: (txt) => ctrl.update(),
          decoration: InputDecoration(
            hintText: 'Enter referral code (if any)',
            hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
            prefixIcon: Icon(Icons.people_alt_rounded, color: AppTheme.textSecondary, size: 22),
            suffixIcon: ctrl.referralCodeCtrl.text.isEmpty
                ? SizedBox.shrink()
                : IconButton(
                    onPressed: ctrl.clearReferralCode,
                    icon: Icon(Icons.close_rounded, color: AppTheme.textLight, size: 20),
                  ),
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
        const SizedBox(height: 6),
        Text(
          'If you were referred by another doctor, enter their referral code here',
          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildEnhancedMultiSelectField({
    required BuildContext context,
    required RxList<ServiceModel> items,
    required RxList<ServiceModel> selectedItems,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Obx(
      () => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selectedItems.isEmpty ? AppTheme.borderColor : AppTheme.primaryBlue.withOpacity(0.3), width: selectedItems.isEmpty ? 1 : 1.5),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppTheme.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedItems.isEmpty ? hint : '${selectedItems.length} service${selectedItems.length > 1 ? 's' : ''} selected',
                      style: GoogleFonts.inter(color: selectedItems.isEmpty ? AppTheme.textLight : AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    if (selectedItems.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        selectedItems.map((e) => e.name).join(', '),
                        style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.arrow_drop_down_rounded, color: AppTheme.textSecondary, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedServicesPreview(RegisterCtrl ctrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppTheme.primaryBlue, size: 18),
              const SizedBox(width: 8),
              Text(
                'Selected Services',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ctrl.selectedServices.map((service) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  service.name,
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primaryBlue),
                ),
              );
            }).toList(),
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
        onPressed: () => Get.back(),
      ),
    );
  }

  void _showServicesSelection(BuildContext context, RegisterCtrl ctrl) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: MultiSelectBottomSheet(
          title: 'Select Medical Services',
          items: ctrl.services,
          selectedItems: ctrl.selectedServices,
          onSelectionChanged: ctrl.updateSelectedServices,
          itemType: 'services',
        ),
      ),
    );
  }
}
