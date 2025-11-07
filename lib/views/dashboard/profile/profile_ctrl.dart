import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:prime_health_doctors/models/user_model.dart';
import 'package:prime_health_doctors/utils/config/session.dart';
import 'package:prime_health_doctors/utils/helper.dart';
import 'package:prime_health_doctors/utils/routes/route_name.dart';
import 'package:prime_health_doctors/utils/storage.dart';
import 'package:prime_health_doctors/utils/toaster.dart';
import 'package:prime_health_doctors/views/auth/auth_service.dart';
import 'package:prime_health_doctors/views/dashboard/home/home_ctrl.dart';

class ProfileCtrl extends GetxController {
  var user = UserModel().obs;
  var isLoading = false.obs, isSpecialtyLoading = false.obs, isLoadingSlots = false.obs, hasMoreSlots = true.obs;
  var isServicesLoading = false.obs;
  bool isEditMode = false;

  var avatar = Rx<File?>(null), logo = Rx<File?>(null);
  var certificationDocuments = <int, File>{}.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController specialtyController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController consultationFeeController = TextEditingController();
  final TextEditingController followUpFeeController = TextEditingController();

  var services = <dynamic>[].obs, specialities = <dynamic>[].obs;
  var selectedSpecialty = ''.obs, selectedSpecialtyName = ''.obs;
  var selectedService = ''.obs, selectedServiceName = ''.obs;
  var certifications = <Map<String, dynamic>>[].obs, slots = <Map<String, dynamic>>[].obs;
  var currentPage = 1.obs;
  var startDate = Rx<DateTime?>(null), endDate = Rx<DateTime?>(null);

  AuthService get authService => Get.find<AuthService>();

  @override
  void onInit() {
    loadUserData();
    loadSpecialities();
    loadServices();
    super.onInit();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    try {
      final profileData = await authService.getProfile();
      if (profileData != null && profileData['doctor'] != null) {
        _updateUserFromApi(profileData['doctor']);
      }
      _updateControllers();
    } catch (e) {
      toaster.error('Failed to load profile: $e');
    } finally {
      isLoading.value = false;
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

  Future<void> loadSpecialities() async {
    isSpecialtyLoading.value = true;
    try {
      final data = await authService.getSpecialities("");
      specialities.assignAll(data);
    } finally {
      isSpecialtyLoading.value = false;
    }
  }

  void setSelectedService(dynamic service) {
    if (service == null) return;
    selectedService.value = service["_id"] ?? '';
    selectedServiceName.value = service["name"] ?? '';
    update();
  }

  Future<void> loadSlots({bool loadMore = false, bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasMoreSlots.value = true;
      slots.clear();
    }
    if (!loadMore) {
      isLoadingSlots.value = true;
    }
    try {
      final slotsData = await authService.getSlots({"page": currentPage.value, "limit": 20, "startDate": startDate.value, "endDate": endDate.value});
      if (slotsData != null) {
        final List<Map<String, dynamic>> newSlots = slotsData['docs']?.cast<Map<String, dynamic>>() ?? [];
        final int totalPages = int.tryParse(slotsData['totalPages'].toString()) ?? 1;
        if (loadMore) {
          slots.addAll(newSlots);
        } else {
          slots.assignAll(newSlots);
        }
        hasMoreSlots.value = currentPage.value < totalPages;
        if (loadMore) {
          currentPage.value++;
        }
      }
    } catch (e) {
      toaster.error('Failed to load slots: $e');
    } finally {
      isLoadingSlots.value = false;
    }
  }

  Future<void> loadMoreSlots() async {
    if (!isLoadingSlots.value && hasMoreSlots.value) {
      await loadSlots(loadMore: true);
    }
  }

  void applySlotsFilters({DateTime? start, DateTime? end}) {
    startDate.value = start ?? startDate.value;
    endDate.value = end ?? endDate.value;
    loadSlots(refresh: true);
  }

  void clearSlotsFilters() {
    startDate.value = null;
    endDate.value = null;
    loadSlots(refresh: true);
  }

  Future<void> manageSlots(List<Map<String, dynamic>> slotsData) async {
    isLoading.value = true;
    try {
      final request = {
        "slots": slotsData.map((slot) => {"startTime": slot['startTime'], "endTime": slot['endTime'], "isRecurring": slot['isRecurring'] ?? true}).toList(),
      };
      final success = await authService.manageSlots(request);
      if (success) {
        await loadSlots();
      }
    } catch (e) {
      toaster.error('Failed to update slots: $e');
    } finally {
      isLoading.value = false;
    }
  }

  deleteSlots(int index) async {
    await authService.deleteSlot({"slotId": slots[index]["_id"]});
    slots.removeAt(index);
  }

  Future<void> _updateUserFromApi(Map<String, dynamic> data) async {
    user.value = UserModel(
      id: data['_id']?.toString() ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      mobile: data['mobileNo'] ?? '',
      license: data['license'] ?? '',
      specialty: data['specialty']?.toString() ?? '',
      services: data['services']?["_id"]?.toString() ?? '',
      bio: data['bio'] ?? '',
      profileImage: data['profileImage'] ?? '',
      logo: data['logo'] ?? '',
      pricing: data['pricing'] != null ? Pricing.fromJson(data['pricing']) : Pricing(),
      certifications: data['certifications'] != null ? List<Certification>.from(data['certifications'].map((x) => Certification.fromJson(x))) : [],
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : DateTime.now(),
    );
    selectedService.value = data['services']?["_id"] ?? '';
    selectedServiceName.value = data['services']?["name"] ?? '';
    if(selectedService.value.isNotEmpty) {
      final getSpecialities = await authService.getSpecialities(selectedService.value);
      if (getSpecialities.isNotEmpty) {
        int index = getSpecialities.indexWhere((e) => e["_id"].toString() == data['specialty'].toString());
        if (index != -1) {
          selectedSpecialty.value = getSpecialities[index]["_id"] ?? '';
          selectedSpecialtyName.value = getSpecialities[index]["name"] ?? '';
        }
      }
    }
    certifications.assignAll(
      user.value.certifications.map((cert) => {'name': cert.name, 'issuedBy': cert.issuedBy, 'issueDate': cert.issueDate.toIso8601String().split('T')[0], 'document': cert.document}).toList(),
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
    consultationFeeController.text = user.value.pricing.consultationFee.toString();
    followUpFeeController.text = user.value.pricing.followUpFee.toString();
    selectedSpecialty.value = user.value.specialty;
  }

  void setSelectedSpecialty(dynamic specialty) {
    selectedSpecialty.value = specialty["_id"] ?? '';
    selectedSpecialtyName.value = specialty["name"] ?? '';
    specialtyController.text = selectedSpecialtyName.value;
    update();
  }

  void toggleEditMode() {
    isEditMode = !isEditMode;
    if (isEditMode) {
      consultationFeeController.text = user.value.pricing.consultationFee.toString();
      followUpFeeController.text = user.value.pricing.followUpFee.toString();
    }
    update();
  }

  Future<void> pickAvatar() async {
    final result = await helper.pickImage();
    if (result != null) {
      avatar.value = result;
      if (avatar.value != null) {
        final formData = dio.FormData.fromMap({});
        formData.files.add(MapEntry('profileImage', await dio.MultipartFile.fromFile(avatar.value!.path, filename: 'profile.jpg')));
        final success = await authService.updateProfile(formData);
        if (success) {
          await loadUserData();
          final homeCtrl = Get.find<HomeCtrl>();
          homeCtrl.loadUserData();
          toaster.success('Profile updated successfully');
        }
      }
    }
  }

  Future<void> pickLogo() async {
    final result = await helper.pickImage();
    if (result != null) {
      logo.value = result;
      if (logo.value != null) {
        final formData = dio.FormData.fromMap({});
        formData.files.add(MapEntry('logo', await dio.MultipartFile.fromFile(logo.value!.path, filename: 'logo.jpg')));
        final success = await authService.updateProfile(formData);
        if (success) {
          await loadUserData();
          final homeCtrl = Get.find<HomeCtrl>();
          homeCtrl.loadUserData();
          toaster.success('Profile updated successfully');
        }
      }
    }
  }

  Future<void> pickCertificationDocument(int index) async {
    final result = await helper.pickImage(source: ImageSource.gallery);
    if (result != null) {
      certificationDocuments[index] = result;
      update();
    }
  }

  void addCertification() {
    if (certifications.isNotEmpty && certifications.last["name"] == "") {
      toaster.warning("Current certification name is missing...!");
      return;
    }
    certifications.add({'name': '', 'issuedBy': '', 'issueDate': DateTime.now().toIso8601String().split('T')[0], 'document': ''});
  }

  void updateCertification(int index, String field, dynamic value) {
    if (index < certifications.length) {
      certifications[index][field] = value;
      certifications.refresh();
    }
  }

  void removeCertification(int index) {
    if (index < certifications.length) {
      certifications.removeAt(index);
      certificationDocuments.remove(index);
    }
  }

  Future<void> saveProfile() async {
    if (_validateForm()) {
      isLoading.value = true;
      try {
        final certs = certifications.map((cert) {
          final Map<String, dynamic> map = {'name': cert['name']?.toString() ?? '', 'issuedBy': cert['issuedBy']?.toString() ?? '', 'issueDate': cert['issueDate']?.toString() ?? ''};
          final document = cert['document']?.toString();
          if (document != null && document.isNotEmpty) {
            map['document'] = document;
          }
          return map;
        }).toList();
        Map<String, dynamic> json = {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'mobileNo': mobileController.text.trim(),
          'license': licenseController.text.trim(),
          'specialty': selectedSpecialty.value,
          'services': selectedService.value,
          'bio': bioController.text.trim(),
          "certifications": certs,
          'pricing': {'consultationFee': int.tryParse(consultationFeeController.text) ?? 500, 'followUpFee': int.tryParse(followUpFeeController.text) ?? 300},
        };
        final formData = dio.FormData.fromMap(json);
        if (certificationDocuments.isNotEmpty) {
          certificationDocuments.forEach((index, file) async {
            if (file.path.isNotEmpty) {
              formData.files.add(MapEntry('certificate', await dio.MultipartFile.fromFile(file.path, filename: 'cert_$index.pdf')));
            }
          });
        }
        final success = await authService.updateProfile(formData);
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
    if (nameController.text.isEmpty || emailController.text.isEmpty || mobileController.text.isEmpty || licenseController.text.isEmpty || selectedSpecialty.isEmpty || selectedService.isEmpty) {
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
    if (consultationFeeController.text.isEmpty || followUpFeeController.text.isEmpty) {
      toaster.warning('Please enter pricing information');
      return false;
    }
    for (int i = 0; i < certifications.length; i++) {
      final cert = certifications[i];
      if (cert['name']?.isEmpty ?? true) {
        toaster.warning('Please enter certification name for certification ${i + 1}');
        return false;
      }
      if (cert['issuedBy']?.isEmpty ?? true) {
        toaster.warning('Please enter issuing authority for certification ${i + 1}');
        return false;
      }
    }
    return true;
  }

  String formatSlotTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour % 12 == 0 ? 12 : hour % 12;
      return '$displayHour:$minute $period';
    } catch (e) {
      return 'Invalid time';
    }
  }

  String formatSlotDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  bool isRecurringSlot(Map<String, dynamic> slot) {
    return slot['isRecurring'] == true;
  }

  Future<void> logout() async {
    try {
      await clearStorage();
      Get.offAllNamed(AppRouteNames.login);
    } catch (e) {
      toaster.error('Failed to logout: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await clearStorage();
      Get.offAllNamed(AppRouteNames.login);
    } catch (e) {
      toaster.error('Failed to logout: $e');
    }
  }
}
