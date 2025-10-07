import 'package:get/get.dart';
import 'package:prime_health_doctors/models/appointment_model.dart';

class AppointmentsCtrl extends GetxController {
  var appointmentsList = <AppointmentModel>[
    AppointmentModel(id: 1, patientName: 'Alice Johnson', date: '2025-10-03', time: '09:00 AM', service: 'Ortho', status: 'confirmed'),
    AppointmentModel(id: 2, patientName: 'Bob Smith', date: '2025-10-03', time: '10:30 AM', service: 'Neuro', status: 'pending'),
    AppointmentModel(id: 3, patientName: 'Charlie Davis', date: '2025-10-04', time: '11:45 AM', service: 'Sports', status: 'confirmed'),
    AppointmentModel(id: 4, patientName: 'Dana Evans', date: '2025-10-04', time: '02:00 PM', service: 'Maternity', status: 'cancelled'),
    AppointmentModel(id: 5, patientName: 'Eve Franklin', date: '2025-10-05', time: '03:15 PM', service: 'Fitness', status: 'confirmed'),
    AppointmentModel(id: 6, patientName: 'Frank Green', date: '2025-10-05', time: '04:30 PM', service: 'Geriatric', status: 'pending'),
    AppointmentModel(id: 7, patientName: 'Grace Harris', date: '2025-10-06', time: '05:45 PM', service: 'Pediatric', status: 'completed'),
    AppointmentModel(id: 8, patientName: 'Henry Irving', date: '2025-10-06', time: '07:00 PM', service: 'Pain Management', status: 'confirmed'),
    AppointmentModel(id: 9, patientName: 'Isabella James', date: '2025-10-07', time: '08:30 AM', service: 'Ortho', status: 'pending'),
    AppointmentModel(id: 10, patientName: 'Jack King', date: '2025-10-07', time: '01:00 PM', service: 'Sports', status: 'completed'),
  ].obs;

  var filteredAppointments = <AppointmentModel>[].obs;

  var searchQuery = ''.obs, selectedStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    filteredAppointments.assignAll(appointmentsList);
  }

  void searchAppointments(String query) {
    searchQuery.value = query;
    _applyAppointmentFilters();
  }

  void _applyAppointmentFilters() {
    List<AppointmentModel> filtered = appointmentsList;
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where(
            (appointment) =>
                appointment.patientName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                appointment.service.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                appointment.date.contains(searchQuery.value) ||
                appointment.time.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
    }
    if (selectedStatus.value.isNotEmpty) {
      filtered = filtered.where((appointment) => appointment.status.toLowerCase() == selectedStatus.value.toLowerCase()).toList();
    }
    filteredAppointments.assignAll(filtered);
  }

  void filterAppointmentsByStatus(String status) {
    if (status == "all") {
      clearAppointmentFilters();
      return;
    }
    selectedStatus.value = status;
    _applyAppointmentFilters();
  }

  void clearAppointmentFilters() {
    selectedStatus.value = '';
    searchQuery.value = '';
    _applyAppointmentFilters();
  }
}
