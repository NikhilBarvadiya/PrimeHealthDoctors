import 'package:get/get.dart';
import 'package:prime_health_doctors/models/appointment_model.dart';
import 'package:prime_health_doctors/models/patient_model.dart';
import 'package:prime_health_doctors/utils/config/session.dart';
import 'package:prime_health_doctors/utils/storage.dart';
import 'package:prime_health_doctors/utils/toaster.dart';
import 'package:prime_health_doctors/views/auth/auth_service.dart';

class HomeCtrl extends GetxController {
  var userName = 'Dr. John Smith'.obs;
  var todayAppointments = <AppointmentModel>[].obs;
  var consultedPatients = <PatientModel>[].obs;
  var isLoading = false.obs, isLoadingPatients = false.obs;

  AuthService get authService => Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    onAPICalling();
  }

  void loadUserData() async {
    try {
      final userData = await read(AppSession.userData);
      if (userData != null) {
        userName.value = userData['name'] ?? "Dr. John Smith";
      }
    } catch (e) {
      toaster.error('Failed to load user data: $e');
    }
  }

  onAPICalling() async {
    loadUserData();
    await loadTodayAppointments();
    await loadConsultedPatients();
  }

  Future<void> loadTodayAppointments() async {
    try {
      isLoading.value = true;
      final now = DateTime.now();
      final todayDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final response = await authService.bookings({"page": 1, "limit": 10, "startDate": todayDate, "endDate": todayDate});
      if (response != null && response['docs'] != null) {
        final List<dynamic> data = response['docs'];
        final todayApps = data.map((item) => AppointmentModel.fromMap(item)).toList();
        todayAppointments.assignAll(todayApps);
      } else {
        todayAppointments.clear();
      }
    } catch (e) {
      toaster.error('Failed to load appointment data: $e');
      todayAppointments.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadConsultedPatients() async {
    try {
      isLoadingPatients.value = true;
      final response = await authService.getConsultedPatients();
      if (response != null && response['patients'] != null) {
        final List<dynamic> data = response['patients'];
        final patients = data.map((item) => PatientModel.fromMap(item)).toList();
        consultedPatients.assignAll(patients);
      } else {
        consultedPatients.clear();
      }
    } catch (e) {
      toaster.error('Failed to load consulted patients: $e');
      consultedPatients.clear();
    } finally {
      isLoadingPatients.value = false;
    }
  }

  int get todayAppointmentsCount {
    return todayAppointments.length;
  }

  List<AppointmentModel> get upcomingAppointments {
    return todayAppointments.where((appointment) {
      return appointment.status != 'completed' && appointment.status != 'cancelled';
    }).toList();
  }
}
