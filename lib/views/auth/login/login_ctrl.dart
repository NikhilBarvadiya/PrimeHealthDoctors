import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_health_doctors/service/calling_service.dart';
import 'package:prime_health_doctors/utils/helper.dart';
import 'package:prime_health_doctors/utils/routes/route_name.dart';
import 'package:prime_health_doctors/utils/toaster.dart';
import 'package:prime_health_doctors/views/auth/auth_service.dart';

class LoginCtrl extends GetxController {
  final mobileCtrl = TextEditingController();
  var isLoading = false.obs;

  AuthService get authService => Get.find<AuthService>();

  Future<void> login() async {
    if (mobileCtrl.text.isEmpty) {
      return toaster.warning('Please enter your mobile number');
    }
    if (!GetUtils.isPhoneNumber(mobileCtrl.text)) {
      return toaster.warning('Please enter a valid mobile number');
    }
    isLoading.value = true;
    try {
      final machineId = await helper.getDeviceUniqueId();
      String getToken = await CallingService().getToken() ?? "";
      final loginRequest = {'mobileNo': mobileCtrl.text.trim(), 'machineId': machineId, "fcm": getToken};
      await authService.login(loginRequest);
    } catch (err) {
      toaster.error('Login error: ${err.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() => Get.toNamed(AppRouteNames.register);
}
