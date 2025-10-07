import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_health_doctors/models/service_model.dart';
import 'package:prime_health_doctors/utils/config/session.dart';
import 'package:prime_health_doctors/utils/routes/route_name.dart';
import 'package:prime_health_doctors/utils/storage.dart';
import 'package:prime_health_doctors/utils/toaster.dart';

class RegisterCtrl extends GetxController {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final clinicCtrl = TextEditingController();
  final specialtyCtrl = TextEditingController();
  final referralCodeCtrl = TextEditingController();

  var isLoading = false.obs, isPasswordVisible = false.obs;
  var services = <ServiceModel>[
    ServiceModel(id: 1, name: 'Ortho', description: 'Comprehensive rehabilitation for joint and muscle injuries, focusing on strength and mobility.', icon: Icons.fitness_center, isActive: true),
    ServiceModel(id: 2, name: 'Neuro', description: 'Specialized therapy for neurological conditions to enhance motor skills and coordination.', icon: Icons.psychology, isActive: false),
    ServiceModel(id: 3, name: 'Sports', description: 'Tailored recovery programs for athletes to regain peak performance post-injury.', icon: Icons.sports_tennis, isActive: true),
    ServiceModel(id: 4, name: 'Maternity', description: 'Supportive exercises for prenatal and postnatal care to promote maternal health.', icon: Icons.pregnant_woman, isActive: true),
    ServiceModel(id: 5, name: 'Fitness', description: 'Personalized fitness plans to improve strength, flexibility, and overall wellness.', icon: Icons.directions_run, isActive: false),
    ServiceModel(id: 6, name: 'Geriatric', description: 'Gentle therapy for elderly patients to improve mobility and reduce pain.', icon: Icons.elderly, isActive: true),
    ServiceModel(id: 7, name: 'Pediatric', description: 'Therapy for children to support developmental and physical milestones.', icon: Icons.child_care, isActive: true),
    ServiceModel(id: 8, name: 'Pain Management', description: 'Advanced techniques to alleviate chronic pain and improve quality of life.', icon: Icons.healing, isActive: false),
  ].obs;
  var selectedServices = <ServiceModel>[].obs;

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  void updateSelectedServices(List<ServiceModel> newSelection) {
    selectedServices.assignAll(newSelection);
  }

  void clearReferralCode() => referralCodeCtrl.clear();

  Future<void> register() async {
    if (emailCtrl.text.isEmpty) {
      return toaster.warning('Please enter your email');
    }
    if (!GetUtils.isEmail(emailCtrl.text)) {
      return toaster.warning('Please enter a valid email');
    }
    if (passwordCtrl.text.isEmpty) {
      return toaster.warning('Please enter your password');
    }
    if (passwordCtrl.text.length < 6) {
      return toaster.warning('Password must be at least 6 characters');
    }
    if (mobileCtrl.text.isEmpty) {
      return toaster.warning('Please enter your mobile number');
    }
    if (!GetUtils.isPhoneNumber(mobileCtrl.text)) {
      return toaster.warning('Please enter a valid mobile number');
    }
    if (clinicCtrl.text.isEmpty) {
      return toaster.warning('Please enter your clinic name');
    }
    if (specialtyCtrl.text.isEmpty) {
      return toaster.warning('Please enter the specialty');
    }
    if (selectedServices.isEmpty) {
      return toaster.warning('Please select at least one service');
    }
    isLoading.value = true;
    try {
      final request = {
        'email': emailCtrl.text.trim(),
        'password': passwordCtrl.text.trim(),
        'mobile': mobileCtrl.text.trim(),
        'clinic': clinicCtrl.text.trim(),
        'specialty': specialtyCtrl.text.trim(),
        'services': selectedServices.map((e) => e.name).toList(),
        'referralCode': referralCodeCtrl.text.trim().isNotEmpty ? referralCodeCtrl.text.trim() : null,
        'ownReferralCode': _generateReferralCode(),
        'registrationDate': DateTime.now().toIso8601String(),
      };
      await write(AppSession.token, DateTime.now().toIso8601String());
      await write(AppSession.userData, request);
      toaster.success("Congratulations, Registration successfully completed.");
      emailCtrl.clear();
      passwordCtrl.clear();
      mobileCtrl.clear();
      clinicCtrl.clear();
      specialtyCtrl.clear();
      selectedServices.clear();
      Get.toNamed(AppRouteNames.dashboard);
    } finally {
      isLoading.value = false;
    }
  }

  String _generateReferralCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch % 10000;
    return 'PH${timestamp.toString().substring(8)}${random.toString().padLeft(4, '0')}';
  }

  void goToLogin() => Get.toNamed(AppRouteNames.login);
}
