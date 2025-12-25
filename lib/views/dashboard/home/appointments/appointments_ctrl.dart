import 'package:get/get.dart';
import 'package:prime_health_doctors/models/appointment_model.dart';
import 'package:prime_health_doctors/utils/toaster.dart';
import 'package:prime_health_doctors/views/auth/auth_service.dart';

class AppointmentsCtrl extends GetxController {
  var allAppointments = <AppointmentModel>[].obs;
  var isLoading = false.obs, isRefreshing = false.obs, isLoadingMore = false.obs, hasMore = true.obs;
  var selectedStatus = ''.obs;
  var currentPage = 1;
  final limit = 20;

  final List<Map<String, dynamic>> statusFilters = [
    {'label': 'All', 'value': ''},
    {'label': 'Scheduled', 'value': 'scheduled'},
    {'label': 'Confirmed', 'value': 'confirmed'},
    {'label': 'Completed', 'value': 'completed'},
    {'label': 'Cancelled', 'value': 'cancelled'},
    {'label': 'No-Show', 'value': 'no-show'},
    {'label': 'Rescheduled', 'value': 'rescheduled'},
  ];

  AuthService get authService => Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  List<AppointmentModel> get filteredAppointments {
    if (selectedStatus.value.isEmpty) return allAppointments;
    return allAppointments.where((appointment) => appointment.status.toLowerCase() == selectedStatus.value.toLowerCase()).toList();
  }

  bool shouldShowLoadMore(int index) {
    return index >= allAppointments.length && hasMore.value && !isLoadingMore.value;
  }

  bool shouldShowEndOfList(int index) {
    return index >= allAppointments.length && !hasMore.value && allAppointments.isNotEmpty;
  }

  Future<void> loadAppointments() async {
    try {
      isLoading.value = true;
      currentPage = 1;
      hasMore.value = true;
      final response = await authService.bookings({"page": currentPage, "limit": limit, "status": selectedStatus.value.isEmpty ? null : selectedStatus.value});
      if (response != null && response['docs'] != null) {
        final List<dynamic> data = response['docs'];
        final appointments = data.map((item) => AppointmentModel.fromMap(item)).toList();
        allAppointments.assignAll(appointments);
        hasMore.value = data.length >= limit;
        if (appointments.isEmpty) {
          toaster.info("No appointments found");
        }
      } else {
        allAppointments.clear();
        hasMore.value = false;
      }
    } catch (e) {
      allAppointments.clear();
      hasMore.value = false;
      toaster.error('Failed to load appointments: ${e.toString()}');
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> loadMoreAppointments() async {
    if (isLoadingMore.value || !hasMore.value) return;
    try {
      isLoadingMore.value = true;
      currentPage++;
      final response = await authService.bookings({"page": currentPage, "limit": limit, "status": selectedStatus.value.isEmpty ? null : selectedStatus.value});
      if (response != null && response['docs'] != null) {
        final List<dynamic> data = response['docs'];
        final appointments = data.map((item) => AppointmentModel.fromMap(item)).toList();
        allAppointments.addAll(appointments);
        hasMore.value = data.length >= limit;
      } else {
        hasMore.value = false;
        currentPage--;
      }
    } catch (e) {
      currentPage--;
      hasMore.value = false;
      toaster.error('Failed to load appointments');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshAppointments() async {
    isRefreshing.value = true;
    await loadAppointments();
  }

  void filterAppointmentsByStatus(String status) {
    selectedStatus.value = status;
    loadAppointments();
  }

  void clearAllFilters() {
    selectedStatus.value = '';
    loadAppointments();
  }

  Future<void> updateAppointmentStatus(String appointmentId, String newStatus) async {
    try {
      isLoading.value = true;
      final response = await authService.updateBookingStatus({'bookingId': appointmentId, 'status': newStatus});
      if (response != null) {
        final index = allAppointments.indexWhere((appointment) => appointment.id == appointmentId);
        if (index != -1) {
          allAppointments[index].status = newStatus;
          allAppointments.refresh();
        }
        toaster.success('Appointment status changed to ${_getStatusDisplayText(newStatus)}');
      } else {
        throw Exception('Failed to update appointment status');
      }
    } catch (e) {
      toaster.error('Failed to update appointment: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  String _getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return 'Scheduled';
      case 'confirmed':
        return 'Confirmed';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'no-show':
        return 'No Show';
      case 'rescheduled':
        return 'Rescheduled';
      default:
        return status.capitalizeFirst ?? status;
    }
  }

  int get todayAppointmentsCount {
    final now = DateTime.now();
    return allAppointments.where((appointment) {
      final appointmentDate = DateTime(appointment.appointmentDate.year, appointment.appointmentDate.month, appointment.appointmentDate.day);
      final today = DateTime(now.year, now.month, now.day);
      return appointmentDate == today;
    }).length;
  }

  List<AppointmentModel> getAppointmentsForDate(DateTime date) {
    return allAppointments.where((appointment) {
      final appointmentDate = DateTime(appointment.appointmentDate.year, appointment.appointmentDate.month, appointment.appointmentDate.day);
      final targetDate = DateTime(date.year, date.month, date.day);
      return appointmentDate == targetDate;
    }).toList();
  }

  @override
  void onClose() {
    allAppointments.clear();
    super.onClose();
  }
}
