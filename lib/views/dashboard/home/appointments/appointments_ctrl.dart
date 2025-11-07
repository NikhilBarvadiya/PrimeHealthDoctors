import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_health_doctors/models/appointment_model.dart';
import 'package:prime_health_doctors/views/auth/auth_service.dart';

class AppointmentsCtrl extends GetxController {
  var allAppointments = <AppointmentModel>[].obs;
  var isLoading = false.obs, isRefreshing = false.obs, isLoadingMore = false.obs, hasMore = true;
  var selectedStatus = ''.obs;
  var currentPage = 1;
  final limit = 20;

  AuthService get authService => Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      isLoading.value = true;
      currentPage = 1;
      hasMore = true;
      final response = await authService.bookings({"page": currentPage, "limit": limit, "status": selectedStatus.value});
      if (response != null && response['docs'] != null) {
        final List<dynamic> data = response['docs'];
        final appointments = data.map((item) => AppointmentModel.fromMap(item)).toList();
        allAppointments.assignAll(appointments);
        hasMore = data.length >= limit;
      } else {
        allAppointments.clear();
      }
    } catch (e) {
      allAppointments.clear();
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> loadMoreAppointments() async {
    if (isLoadingMore.value || !hasMore) return;
    try {
      isLoadingMore.value = true;
      currentPage++;
      final response = await authService.bookings({"page": currentPage, "limit": limit, "status": selectedStatus.value});
      if (response != null && response['docs'] != null) {
        final List<dynamic> data = response['docs'];
        final appointments = data.map((item) => AppointmentModel.fromMap(item)).toList();
        allAppointments.addAll(appointments);
        hasMore = data.length >= limit;
      }
    } catch (e) {
      currentPage--;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshAppointments() async {
    isRefreshing.value = true;
    await loadAppointments();
  }

  void filterAppointmentsByStatus(String status) {
    allAppointments.clear();
    selectedStatus.value = status;
    loadAppointments();
  }

  void clearAllFilters() {
    selectedStatus.value = '';
    loadAppointments();
  }

  Future<void> updateAppointmentStatus(String appointmentId, String newStatus) async {
    try {
      final response = await authService.updateBookingStatus({'bookingId': appointmentId, 'status': newStatus});
      if (response != null && response['success'] == true) {
        final index = allAppointments.indexWhere((appointment) => appointment.id == appointmentId);
        if (index != -1) {
          allAppointments[index].status = newStatus;
        }
        Get.snackbar(
          'Success',
          'Appointment status changed to ${newStatus.capitalizeFirst}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: _getStatusColor(newStatus),
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(20),
        );
      } else {
        throw Exception('Failed to update appointment status');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update appointment: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.purple;
      case 'no-show':
        return Colors.grey;
      case 'rescheduled':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
