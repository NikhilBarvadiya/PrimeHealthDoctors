import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/utils/routes/route_name.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/dashboard/profile/profile_ctrl.dart';
import 'package:prime_health_doctors/views/dashboard/profile/ui/slots_management.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileCtrl>();
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverAppBar(
              elevation: 0,
              backgroundColor: AppTheme.backgroundWhite,
              pinned: true,
              floating: true,
              title: Text(
                'Settings',
                style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              leading: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.backgroundLight,
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary, size: 24),
                onPressed: () => Get.close(1),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Clinic & Practice'),
                    const SizedBox(height: 16),
                    _buildSettingsCard(
                      children: [_buildSettingsTile(icon: Icons.schedule_rounded, title: 'Time Slots', subtitle: 'Manage appointment time slots', onTap: () => Get.to(() => const SlotsManagement()))],
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader('Legal & Support'),
                    const SizedBox(height: 16),
                    _buildSettingsCard(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.privacy_tip_rounded,
                          title: 'Privacy Policy',
                          subtitle: 'How we protect your data',
                          onTap: () => _showPolicyPage('Privacy Policy', _privacyPolicyContent),
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.description_rounded,
                          title: 'Terms of Service',
                          subtitle: 'App usage guidelines and terms',
                          onTap: () => _showPolicyPage('Terms of Service', _termsOfServiceContent),
                        ),
                        _buildDivider(),
                        _buildSettingsTile(icon: Icons.help_rounded, title: 'Help & Support', subtitle: 'Get help using the app', onTap: () => _showPolicyPage('Help & Support', _helpSupportContent)),
                        _buildDivider(),
                        _buildSettingsTile(icon: Icons.contact_support_rounded, title: 'Contact Us', subtitle: 'Reach out to our support team', onTap: () => _showContactDialog()),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader('Account Actions'),
                    const SizedBox(height: 16),
                    _buildSettingsCard(
                      children: [
                        _buildSettingsTile(icon: Icons.logout_rounded, title: 'Logout', subtitle: 'Sign out of your account', color: AppTheme.emergencyRed, onTap: () => _showLogoutDialog(ctrl)),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.delete_forever_rounded,
                          title: 'Delete Account',
                          subtitle: 'Permanently remove your account',
                          color: AppTheme.emergencyRed,
                          onTap: () => _showDeleteAccountDialog(ctrl),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    _buildAppFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({required IconData icon, required String title, required String subtitle, VoidCallback? onTap, String? value, Color? color}) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: (color ?? AppTheme.primaryBlue).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color ?? AppTheme.primaryBlue, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: color ?? AppTheme.textPrimary),
      ),
      subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
      trailing: value != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(
                value,
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
              ),
            )
          : Icon(Icons.chevron_right_rounded, color: AppTheme.textLight, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: AppTheme.borderColor),
    );
  }

  Widget _buildAppFooter() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.medical_services_rounded, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 16),
          Text(
            'PrimeHealth Doctors',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 4),
          Text('Version 1.0.0 • © 2024', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          Text(
            'Empowering Healthcare Professionals',
            style: GoogleFonts.inter(fontSize: 12, fontStyle: FontStyle.italic, color: AppTheme.textLight),
          ),
        ],
      ),
    );
  }

  void _showPolicyPage(String title, String content) {
    Get.to(
      () => Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.backgroundWhite,
          title: Text(
            title,
            style: GoogleFonts.inter(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 20),
          ),
          leading: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.backgroundLight,
              padding: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary, size: 24),
            onPressed: () => Get.close(1),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Text(content, style: GoogleFonts.inter(fontSize: 14, height: 1.6, color: AppTheme.textPrimary)),
          ),
        ),
      ),
    );
  }

  void _showContactDialog() {
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
                decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.contact_support_rounded, color: AppTheme.primaryBlue, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Contact Support',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 16),
              _buildContactInfo('Email', 'support@primehealth.com', Icons.email_rounded),
              const SizedBox(height: 12),
              _buildContactInfo('Phone', '+1 (555) 123-4567', Icons.phone_rounded),
              const SizedBox(height: 12),
              _buildContactInfo('Hours', 'Mon - Fri, 9:00 AM - 6:00 PM', Icons.access_time_rounded),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.close(1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Close',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppTheme.backgroundLight, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(ProfileCtrl ctrl) {
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
                child: Icon(Icons.logout_rounded, color: AppTheme.emergencyRed, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Logout',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to logout from your account?',
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
                        ctrl.logout();
                        Get.offAllNamed(AppRouteNames.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.emergencyRed,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Logout',
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

  void _showDeleteAccountDialog(ProfileCtrl ctrl) {
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
                child: Icon(Icons.delete_forever_rounded, color: AppTheme.emergencyRed, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Delete Account',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'This action cannot be undone. All your data, appointments, and patient records will be permanently deleted.',
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
                        ctrl.deleteAccount();
                        Get.offAllNamed(AppRouteNames.login);
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

  final String _privacyPolicyContent = '''
At PrimeHealth Doctors, we are committed to protecting your privacy and securing your medical data. This policy outlines how we collect, use, and safeguard your information.

**Data Collection**
We collect professional information including name, medical qualifications, clinic details, and services offered to provide healthcare services.

**Data Usage**
Your information is used to:
- Manage patient appointments and records
- Facilitate communication with patients
- Provide medical services and consultations
- Maintain professional healthcare standards

**Data Protection**
We implement industry-standard security measures:
- End-to-end encryption for all medical data
- Secure cloud storage with regular backups
- Access controls and authentication protocols
- Regular security audits and updates

**Data Sharing**
We do not share your professional data with third parties without explicit consent, except when required by law or for medical emergency situations.

**Your Rights**
You have the right to:
- Access your personal data
- Request corrections to inaccurate information
- Delete your account and associated data
- Export your professional data

For privacy concerns, contact our Data Protection Officer at privacy@primehealth.com.
''';

  final String _termsOfServiceContent = '''
By using PrimeHealth Doctors, you agree to these terms and conditions:

**Professional Use**
The app is designed for licensed healthcare professionals to manage their practice and provide medical services.

**Account Responsibility**
You are responsible for:
- Maintaining accurate professional information
- Securing your login credentials
- All activities under your account
- Compliance with medical regulations

**Medical Standards**
You agree to:
- Maintain professional medical standards
- Provide accurate medical information
- Follow applicable healthcare laws
- Maintain patient confidentiality

**Service Availability**
We strive to maintain 24/7 service availability but may perform maintenance updates. Emergency features will remain accessible.

**Liability**
PrimeHealth Doctors provides a platform for healthcare management. Medical decisions and treatments remain the responsibility of the licensed practitioner.

**Updates**
These terms may be updated to reflect changes in services or regulations. Continued use constitutes acceptance of updated terms.

For questions about these terms, contact legal@primehealth.com.
''';

  final String _helpSupportContent = '''
**Getting Started**
1. Complete your professional profile with accurate information
2. Set up your clinic availability and working hours
3. Add the medical services you offer
4. Configure notification preferences

**Managing Appointments**
- View upcoming appointments in your dashboard
- Reschedule or cancel appointments as needed
- Set automatic appointment reminders
- Manage patient follow-ups

**Patient Management**
- Maintain patient medical records securely
- Track treatment progress and notes
- Send prescriptions and medical advice
- Manage billing and payments

**Technical Support**
Common solutions for technical issues:
- Clear app cache and restart application
- Ensure stable internet connection
- Update to the latest app version
- Check device compatibility

**Emergency Support**
For urgent technical issues affecting patient care:
Email: emergency-support@primehealth.com
Phone: +1 (555) 911-SUPPORT
Available 24/7 for critical issues

**Feedback & Suggestions**
We continuously improve our platform. Share your feedback at feedback@primehealth.com.

**Contact Information**
General Support: support@primehealth.com
Technical Issues: tech@primehealth.com
Billing Inquiries: billing@primehealth.com
Business Hours: Mon-Fri, 8:00 AM - 8:00 PM EST

We're committed to supporting your medical practice!
''';
}
