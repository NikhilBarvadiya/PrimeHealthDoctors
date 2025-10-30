import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_health_doctors/models/user_model.dart';
import 'package:prime_health_doctors/utils/config/session.dart';
import 'package:prime_health_doctors/utils/helper.dart';
import 'package:prime_health_doctors/utils/storage.dart';
import 'package:prime_health_doctors/utils/toaster.dart';
import 'package:prime_health_doctors/views/auth/auth_service.dart';
import 'package:prime_health_doctors/views/dashboard/home/home_ctrl.dart';

class ProfileCtrl extends GetxController {
  var user = UserModel().obs;
  var isLoading = false.obs;
  bool isEditMode = false;

  var avatar = Rx<File?>(null);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController specialtyController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  AuthService get authService => Get.find<AuthService>();

  @override
  void onInit() {
    loadUserData();
    super.onInit();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    try {
      final profileData = await authService.getProfile();
      if (profileData != null && profileData['doctor'] != null) {
        final data = await authService.getSpecialities();
        if (data.isNotEmpty) {
          int index = data.indexWhere((e) => e["_id"].toString() == profileData['doctor']['specialty'].toString());
          if (index != -1) {
            profileData["doctor"]["specialty"] = data[index]["name"];
          }
        }
        _updateUserFromApi(profileData['doctor']);
      }
      _updateControllers();
    } catch (e) {
      toaster.error('Failed to load profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateUserFromApi(Map<String, dynamic> data) {
    user.value = UserModel(
      id: data['_id']?.toString() ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      mobile: data['mobileNo'] ?? '',
      license: data['license'] ?? '',
      specialty: data['specialty']?.toString() ?? '',
      bio: data['bio'] ?? '',
      profileImage: data['profileImage'] ?? '',
      pricing: data['pricing'] != null ? Pricing.fromJson(data['pricing']) : Pricing(),
      certifications: data['certifications'] != null ? List<Certification>.from(data['certifications'].map((x) => Certification.fromJson(x))) : [],
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : DateTime.now(),
    );
    write(AppSession.userData, data);
  }

  void _updateControllers() {
    nameController.text = user.value.name;
    emailController.text = user.value.email;
    mobileController.text = user.value.mobile;
    licenseController.text = user.value.license;
    specialtyController.text = user.value.specialty;
    bioController.text = user.value.bio;
  }

  void toggleEditMode() {
    isEditMode = !isEditMode;
    if (!isEditMode) {
      loadUserData();
    }
    update();
  }

  Future<void> pickAvatar() async {
    final result = await helper.pickImage();
    if (result != null) {
      avatar.value = result;
    }
  }

  Future<void> saveProfile() async {
    if (_validateForm()) {
      isLoading.value = true;
      try {
        final request = {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "mobileNo": mobileController.text.trim(),
          "license": licenseController.text.trim(),
          "specialty": user.value.specialty,
          "bio": bioController.text.trim(),
          "pricing": {"consultationFee": user.value.pricing.consultationFee, "followUpFee": user.value.pricing.followUpFee},
        };

        final success = await authService.updateProfile(request);
        if (success) {
          await loadUserData();
          isEditMode = false;
          update();
          final homeCtrl = Get.find<HomeCtrl>();
          homeCtrl.loadUserData();
          toaster.success('Profile updated successfully');
        }
      } catch (e) {
        toaster.error('Failed to update profile: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  bool _validateForm() {
    if (nameController.text.isEmpty || emailController.text.isEmpty || mobileController.text.isEmpty || licenseController.text.isEmpty || specialtyController.text.isEmpty) {
      toaster.warning('Please fill all required fields');
      return false;
    }
    if (!GetUtils.isEmail(emailController.text)) {
      toaster.warning('Invalid email format');
      return false;
    }
    if (!GetUtils.isPhoneNumber(mobileController.text)) {
      toaster.warning('Invalid mobile number');
      return false;
    }

    return true;
  }

  Future<void> logout() async {
    try {
      await clearStorage();
      Get.offAllNamed('/login');
    } catch (e) {
      toaster.error('Failed to logout: $e');
    }
  }
}
