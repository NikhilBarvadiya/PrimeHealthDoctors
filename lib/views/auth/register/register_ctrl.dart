import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_health_doctors/utils/routes/route_name.dart';
import 'package:prime_health_doctors/utils/toaster.dart';
import 'package:prime_health_doctors/views/auth/auth_service.dart';

class RegisterCtrl extends GetxController {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final specialtyCtrl = TextEditingController();
  final licenseCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final consultationFeeCtrl = TextEditingController(text: '500');
  final followUpFeeCtrl = TextEditingController(text: '300');

  var isLoading = false.obs, isSpecialtyLoading = false.obs, isServicesLoading = false.obs;
  var specialities = <dynamic>[].obs;
  var services = <dynamic>[].obs;
  var selectedSpecialty = ''.obs, selectedSpecialtyName = ''.obs;
  var selectedService = ''.obs, selectedServiceName = ''.obs;

  var certifications = <Map<String, String>>[].obs;

  AuthService get authService => Get.find<AuthService>();

  @override
  void onInit() {
    _loadInitialData();
    super.onInit();
  }

  void _loadInitialData() async {
    await Future.wait([loadServices()]);
  }

  Future<void> loadSpecialities() async {
    isSpecialtyLoading.value = true;
    try {
      final data = await authService.getSpecialities(selectedService.value);
      specialities.assignAll(data);
    } finally {
      isSpecialtyLoading.value = false;
    }
  }

  Future<void> loadServices() async {
    isServicesLoading.value = true;
    try {
      final data = await authService.getServices();
      services.assignAll(data);
    } finally {
      isServicesLoading.value = false;
    }
  }

  void setSelectedSpecialty(dynamic specialty) {
    if (specialty == null) return;
    selectedSpecialty.value = specialty["_id"] ?? '';
    selectedSpecialtyName.value = specialty["name"] ?? '';
  }

  void setSelectedService(dynamic service) {
    if (service == null) return;
    selectedService.value = service["_id"] ?? '';
    selectedServiceName.value = service["name"] ?? '';
    if (selectedService.value.isNotEmpty) {
      loadSpecialities();
    }
  }

  void updateConsultationFee(String fee) {
    consultationFeeCtrl.text = fee;
  }

  void updateFollowUpFee(String fee) {
    followUpFeeCtrl.text = fee;
  }

  void addCertification() {
    if (certifications.isNotEmpty && certifications.last["name"] == "") {
      toaster.warning("Current certification name is missing...!");
      return;
    }
    certifications.add({'name': '', 'issuedBy': '', 'issueDate': DateTime.now().toIso8601String().split('T')[0]});
  }

  void updateCertification(int index, String field, String value) {
    if (index < certifications.length) {
      certifications[index][field] = value;
      certifications.refresh();
    }
  }

  void removeCertification(int index) {
    if (index < certifications.length) {
      certifications.removeAt(index);
    }
  }

  Future<void> register() async {
    if (nameCtrl.text.isEmpty) {
      return toaster.warning('Please enter your name');
    }
    if (emailCtrl.text.isEmpty) {
      return toaster.warning('Please enter your email');
    }
    if (!GetUtils.isEmail(emailCtrl.text)) {
      return toaster.warning('Please enter a valid email');
    }
    if (mobileCtrl.text.isEmpty) {
      return toaster.warning('Please enter your mobile number');
    }
    if (!GetUtils.isPhoneNumber(mobileCtrl.text)) {
      return toaster.warning('Please enter a valid mobile number');
    }
    if (selectedSpecialty.isEmpty) {
      return toaster.warning('Please select your specialty');
    }
    if (selectedService.isEmpty) {
      return toaster.warning('Please select your service');
    }
    if (licenseCtrl.text.isEmpty) {
      return toaster.warning('Please enter your license number');
    }
    if (consultationFeeCtrl.text.isEmpty) {
      return toaster.warning('Please enter consultation fee');
    }
    if (followUpFeeCtrl.text.isEmpty) {
      return toaster.warning('Please enter follow-up fee');
    }
    for (int i = 0; i < certifications.length; i++) {
      final cert = certifications[i];
      if (cert['name']?.isEmpty ?? true) {
        return toaster.warning('Please enter certification name for certification ${i + 1}');
      }
      if (cert['issuedBy']?.isEmpty ?? true) {
        return toaster.warning('Please enter issuing authority for certification ${i + 1}');
      }
    }
    isLoading.value = true;
    try {
      final request = {
        "name": nameCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "mobileNo": mobileCtrl.text.trim(),
        "license": licenseCtrl.text.trim(),
        "specialty": selectedSpecialty.value,
        "services": selectedService.value,
        "bio": bioCtrl.text.trim(),
        "pricing": {"consultationFee": int.tryParse(consultationFeeCtrl.text) ?? 500, "followUpFee": int.tryParse(followUpFeeCtrl.text) ?? 300},
        "certifications": certifications.isNotEmpty
            ? certifications
            : [
                {"name": "Medical License", "issuedBy": "Medical Board", "issueDate": DateTime.now().toIso8601String().split('T')[0]},
              ],
      };
      final success = await authService.registerDoctor(request);
      if (success) {
        _clearForm();
        Get.back();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _clearForm() {
    nameCtrl.clear();
    emailCtrl.clear();
    mobileCtrl.clear();
    licenseCtrl.clear();
    bioCtrl.clear();
    consultationFeeCtrl.text = '500';
    followUpFeeCtrl.text = '300';
    selectedSpecialty.value = '';
    selectedService.value = '';
    certifications.clear();
  }

  void goToLogin() => Get.toNamed(AppRouteNames.login);
}
