import 'package:get/get.dart';
import 'package:prime_health_doctors/views/auth/auth_service.dart';

Future<void> preload() async {
  await Get.putAsync(() => AuthService().init());
}
