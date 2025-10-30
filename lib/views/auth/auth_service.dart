import 'package:get/get.dart';
import 'package:prime_health_doctors/utils/config/session.dart';
import 'package:prime_health_doctors/utils/network/api_index.dart';
import 'package:prime_health_doctors/utils/network/api_manager.dart';
import 'package:prime_health_doctors/utils/routes/route_name.dart';
import 'package:prime_health_doctors/utils/storage.dart';
import 'package:prime_health_doctors/utils/toaster.dart';

class AuthService extends GetxService {
  Future<AuthService> init() async => this;

  Future<List<dynamic>> getSpecialities() async {
    try {
      final response = await ApiManager().call(APIIndex.specialities, {}, ApiType.post);
      if (response.status != 200 || response.data == null) {
        toaster.warning(response.message ?? 'Failed to load specialities');
        return [];
      }
      return response.data['specialities'] ?? [];
    } catch (err) {
      toaster.error('Network error: ${err.toString()}');
      return [];
    }
  }

  Future<bool> registerDoctor(Map<String, dynamic> request) async {
    try {
      final response = await ApiManager().call(APIIndex.register, request, ApiType.post);
      if (response.status != 200) {
        toaster.warning(response.message ?? 'Registration failed');
        return false;
      }
      if (response.data?['accessToken'] != null) {
        await write(AppSession.token, response.data!["accessToken"]);
        await write(AppSession.userData, response.data!["doctor"]);
      }
      toaster.success(response.message ?? 'Registration successful!');
      return true;
    } catch (err) {
      toaster.error('Registration error: ${err.toString()}');
      return false;
    }
  }

  Future<Map<String, dynamic>?> login(Map<String, dynamic> request) async {
    try {
      final response = await ApiManager().call(APIIndex.login, request, ApiType.post);
      if (response.status != 200 || response.data == null) {
        toaster.warning(response.message ?? 'Failed to login');
        return null;
      }
      if (response.message == "OTP sent to mobile number") {
        return response.data;
      } else {
        await write(AppSession.token, response.data!["token"]);
        await write(AppSession.userData, response.data!["doctor"]);
        Get.offAllNamed(AppRouteNames.dashboard);
      }
      return response.data;
    } catch (err) {
      toaster.error('Login error: ${err.toString()}');
      return null;
    }
  }

  Future<bool> sendOTP(Map<String, dynamic> request) async {
    try {
      final response = await ApiManager().call(APIIndex.sendOTP, request, ApiType.post);
      if (response.status == 200) {
        toaster.success('OTP sent successfully');
        return true;
      } else {
        toaster.warning(response.message ?? 'Failed to send OTP');
        return false;
      }
    } catch (err) {
      toaster.error('OTP sending failed: ${err.toString()}');
      return false;
    }
  }

  Future<bool> verifyOTP(Map<String, dynamic> request) async {
    try {
      final response = await ApiManager().call(APIIndex.verifyOTP, request, ApiType.post);
      if (response.status == 200 && response.data != null) {
        if (response.data?['token'] != null) {
          await write(AppSession.token, response.data!["token"]);
          await write(AppSession.userData, response.data!["doctor"]);
        }
        return true;
      } else {
        toaster.warning(response.message ?? 'Invalid OTP');
        return false;
      }
    } catch (err) {
      toaster.error('Verification failed: ${err.toString()}');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final response = await ApiManager().call(APIIndex.getProfile, {}, ApiType.post);
      if (response.status == 200 && response.data != null) {
        return response.data;
      } else {
        toaster.warning(response.message ?? 'Failed to load profile');
        return null;
      }
    } catch (err) {
      toaster.error('Profile loading failed: ${err.toString()}');
      return null;
    }
  }

  Future<bool> updateProfile(dynamic request) async {
    try {
      final response = await ApiManager().call(APIIndex.updateProfile, request, ApiType.post);
      if (response.status == 200) {
        if (response.data != null) {
          await write(AppSession.userData, response.data);
        }
        toaster.success(response.message ?? 'Profile updated successfully');
        return true;
      } else {
        toaster.warning(response.message ?? 'Profile update failed');
        return false;
      }
    } catch (err) {
      toaster.error('Profile update failed: ${err.toString()}');
      return false;
    }
  }

  Future<dynamic> getSlots(Map<String, dynamic> request) async {
    try {
      final response = await ApiManager().call(APIIndex.slots, request, ApiType.post);
      if (response.status == 200 && response.data != null) {
        return response.data;
      } else {
        toaster.warning(response.message ?? 'Failed to load slots');
        return [];
      }
    } catch (err) {
      toaster.error('Slots loading failed: ${err.toString()}');
      return [];
    }
  }

  Future<bool> manageSlots(Map<String, dynamic> request) async {
    try {
      final response = await ApiManager().call(APIIndex.manageSlots, request, ApiType.post);
      if (response.status == 200) {
        toaster.success(response.message ?? 'Slots updated successfully');
        return true;
      } else {
        toaster.warning(response.message ?? 'Failed to update slots');
        return false;
      }
    } catch (err) {
      toaster.error('Slots update failed: ${err.toString()}');
      return false;
    }
  }

  Future<bool> deleteSlot(Map<String, dynamic> request) async {
    try {
      final response = await ApiManager().call(APIIndex.manageSlots, request, ApiType.post);
      if (response.status == 200) {
        toaster.success(response.message ?? 'Slots updated successfully');
        return true;
      } else {
        toaster.warning(response.message ?? 'Failed to update slots');
        return false;
      }
    } catch (err) {
      toaster.error('Slots update failed: ${err.toString()}');
      return false;
    }
  }
}
