import 'package:get/get.dart';
import 'package:prime_health_doctors/utils/config/session.dart';
import 'package:prime_health_doctors/utils/network/api_index.dart';
import 'package:prime_health_doctors/utils/network/api_manager.dart';
import 'package:prime_health_doctors/utils/routes/route_name.dart';
import 'package:prime_health_doctors/utils/storage.dart';
import 'package:prime_health_doctors/utils/toaster.dart';

class AuthService extends GetxService {
  Future<AuthService> init() async => this;

  Future<List<dynamic>> getServices() async {
    try {
      final response = await ApiManager().call(APIIndex.getServices, {}, ApiType.post);
      if (response.status != 200 || response.data == null || response.data == 0) {
        toaster.warning(response.message ?? 'Failed to load services');
        return [];
      }
      return response.data['services'] ?? [];
    } catch (err) {
      toaster.error('Network error: ${err.toString()}');
      return [];
    }
  }

  Future<List<dynamic>> getSpecialities(String serviceId) async {
    try {
      final response = await ApiManager().call(APIIndex.specialities, {"serviceId": serviceId}, ApiType.post);
      if (response.status != 200 || response.data == null || response.data == 0) {
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
      if (response.status != 200 || response.data == null || response.data == 0) {
        toaster.warning(response.message ?? 'Failed to login');
        return null;
      }
      if (response.message == "OTP sent to mobile number.") {
        final doctorId = response.data['doctorId'] ?? response.data['doctor']["id"] ?? response.data['doctor']["_id"];
        final otpRequest = {'mobileNo': request["mobileNo"], 'doctorId': doctorId};
        final otpSent = await sendOTP(otpRequest);
        if (otpSent) {
          Get.toNamed(AppRouteNames.verifyOtp, arguments: {'mobileNo': request["mobileNo"], 'machineId': request["machineId"], 'doctorId': doctorId});
        }
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
      if (response.status == 200 && response.data != null && response.data != 0) {
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
      if (response.status == 200 && response.data != null && response.data != 0) {
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
        if (response.data != null && response.data != 0) {
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
      if (response.status == 200 && response.data != null && response.data != 0) {
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
      final response = await ApiManager().call(APIIndex.deleteSlots, request, ApiType.post);
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

  Future<dynamic> getConsultedPatients() async {
    try {
      final response = await ApiManager().call(APIIndex.patientsConsulted, {}, ApiType.post);
      if (response.status == 200 && response.data != null && response.data != 0) {
        return response.data;
      } else {
        toaster.warning(response.message ?? 'Failed to load bookings');
        return [];
      }
    } catch (err) {
      toaster.error('Bookings loading failed: ${err.toString()}');
      return [];
    }
  }

  Future<dynamic> bookings(Map<String, dynamic> request) async {
    try {
      final response = await ApiManager().call(APIIndex.bookings, request, ApiType.post);
      if (response.status == 200 && response.data != null && response.data != 0) {
        return response.data;
      } else {
        toaster.warning(response.message ?? 'Failed to load bookings');
        return [];
      }
    } catch (err) {
      toaster.error('Bookings loading failed: ${err.toString()}');
      return [];
    }
  }

  Future<Map<String, dynamic>?> updateBookingStatus(Map<String, dynamic> request) async {
    try {
      final response = await ApiManager().call(APIIndex.updateBookingStatus, request, ApiType.post);
      if (response.status == 200 && response.data != null && response.data != 0) {
        return response.data;
      } else {
        toaster.warning(response.message ?? 'Failed to update appointment status');
        return null;
      }
    } catch (err) {
      toaster.error('Status update failed: ${err.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCalls(Map<String, dynamic> request) async {
    try {
      final response = await ApiManager().call(APIIndex.getCalls, request, ApiType.post);
      if (response.status == 200 && response.data != null && response.data != 0) {
        return response.data;
      } else {
        toaster.warning(response.message ?? 'Failed to get call history');
        return null;
      }
    } catch (err) {
      toaster.error('get call history failed: ${err.toString()}');
      return null;
    }
  }
}
