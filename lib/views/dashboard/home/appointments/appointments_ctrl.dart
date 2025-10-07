import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_health_doctors/main.dart';
import 'package:prime_health_doctors/models/appointment_model.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';

class AppointmentsCtrl extends GetxController {
  var filteredAppointments = <AppointmentModel>[].obs;
  var isLoading = false.obs;
  var searchController = TextEditingController();
  var selectedStatus = ''.obs;

  var appointments = <AppointmentModel>[
    AppointmentModel(
      id: '1',
      patientName: 'Rajesh Kumar',
      patientEmail: 'rajesh.kumar@email.com',
      patientPhone: '+91 98765 43210',
      patientAvatar: '',
      date: '2024-01-15',
      time: '10:00 AM',
      service: 'Cardiology Consultation',
      serviceType: 'Specialist Consultation',
      notes: 'Follow-up for hypertension management',
      duration: '45 mins',
      consultationFee: 1500.0,
      paymentStatus: 'paid',
      status: 'confirmed',
      createdAt: DateTime(2024, 1, 10),
      isUrgent: false,
      patientAge: '45',
      patientGender: 'Male',
      medicalHistory: 'Hypertension, Type 2 Diabetes',
      fcmToken: localFCMToken,
    ),
    AppointmentModel(
      id: '2',
      patientName: 'Priya Sharma',
      patientEmail: 'priya.sharma@email.com',
      patientPhone: '+91 98765 43211',
      patientAvatar: '',
      date: '2024-01-15',
      time: '11:30 AM',
      service: 'Orthopedics Checkup',
      serviceType: 'Specialist Consultation',
      notes: 'Post-surgery follow-up for knee replacement',
      duration: '30 mins',
      consultationFee: 1200.0,
      paymentStatus: 'pending',
      status: 'pending',
      createdAt: DateTime(2024, 1, 12),
      isUrgent: false,
      patientAge: '38',
      patientGender: 'Female',
      medicalHistory: 'Knee replacement surgery (2023)',
      fcmToken: localFCMToken,
    ),
    AppointmentModel(
      id: '3',
      patientName: 'Amit Patel',
      patientEmail: 'amit.patel@email.com',
      patientPhone: '+91 98765 43212',
      patientAvatar: '',
      date: '2024-01-16',
      time: '2:15 PM',
      service: 'Neurology Follow-up',
      serviceType: 'Specialist Consultation',
      notes: 'Migraine treatment progress review',
      duration: '60 mins',
      consultationFee: 1800.0,
      paymentStatus: 'paid',
      status: 'confirmed',
      createdAt: DateTime(2024, 1, 8),
      isUrgent: true,
      patientAge: '52',
      patientGender: 'Male',
      medicalHistory: 'Chronic migraines, Sleep disorder',
      fcmToken: localFCMToken,
    ),
    AppointmentModel(
      id: '4',
      patientName: 'Sneha Gupta',
      patientEmail: 'sneha.gupta@email.com',
      patientPhone: '+91 98765 43213',
      patientAvatar: '',
      date: '2024-01-16',
      time: '4:00 PM',
      service: 'Pediatrics Consultation',
      serviceType: 'Specialist Consultation',
      notes: 'Child vaccination and growth monitoring',
      duration: '30 mins',
      consultationFee: 1000.0,
      paymentStatus: 'pending',
      status: 'cancelled',
      createdAt: DateTime(2024, 1, 5),
      isUrgent: false,
      patientAge: '6',
      patientGender: 'Female',
      medicalHistory: 'Regular vaccinations up to date',
      fcmToken: localFCMToken,
    ),
    AppointmentModel(
      id: '5',
      patientName: 'Vikram Singh',
      patientEmail: 'vikram.singh@email.com',
      patientPhone: '+91 98765 43214',
      patientAvatar: '',
      date: '2024-01-17',
      time: '9:45 AM',
      service: 'General Checkup',
      serviceType: 'Primary Care',
      notes: 'Annual health checkup and blood tests review',
      duration: '20 mins',
      consultationFee: 500.0,
      paymentStatus: 'paid',
      status: 'completed',
      createdAt: DateTime(2024, 1, 3),
      isUrgent: false,
      patientAge: '35',
      patientGender: 'Male',
      medicalHistory: 'No significant medical history',
      fcmToken: localFCMToken,
    ),
    AppointmentModel(
      id: '6',
      patientName: 'Anjali Mehta',
      patientEmail: 'anjali.mehta@email.com',
      patientPhone: '+91 98765 43215',
      patientAvatar: '',
      date: '2024-01-17',
      time: '3:30 PM',
      service: 'Dermatology Consultation',
      serviceType: 'Specialist Consultation',
      notes: 'Skin allergy treatment and skincare routine',
      duration: '25 mins',
      consultationFee: 900.0,
      paymentStatus: 'pending',
      status: 'pending',
      createdAt: DateTime(2024, 1, 14),
      isUrgent: false,
      patientAge: '29',
      patientGender: 'Female',
      medicalHistory: 'Seasonal allergies, Eczema',
      fcmToken: localFCMToken,
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    filterAppointments();
  }

  void filterAppointments() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      var filtered = appointments.where((appointment) {
        final matchesSearch =
            searchController.text.isEmpty ||
            appointment.patientName.toLowerCase().contains(searchController.text.toLowerCase()) ||
            appointment.service.toLowerCase().contains(searchController.text.toLowerCase());
        final matchesStatus = selectedStatus.value.isEmpty || appointment.status.toLowerCase() == selectedStatus.value.toLowerCase();
        return matchesSearch && matchesStatus;
      }).toList();
      filteredAppointments.assignAll(filtered);
      isLoading.value = false;
    });
  }

  void searchAppointments(String query) {
    filterAppointments();
  }

  void filterAppointmentsByStatus(String status) {
    selectedStatus.value = status;
    filterAppointments();
  }

  void clearAllFilters() {
    searchController.clear();
    selectedStatus.value = '';
    filterAppointments();
  }

  void updateAppointmentStatus(String appointmentId, String newStatus) {
    final index = appointments.indexWhere((appointment) => appointment.id.toString() == appointmentId);
    if (index != -1) {
      appointments[index].status = newStatus;
      Get.snackbar(
        'Appointment Updated',
        'Appointment status changed to ${newStatus.capitalizeFirst}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: _getStatusColor(newStatus),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(20),
      );
    }
    filterAppointments();
    update();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppTheme.accentGreen;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return AppTheme.emergencyRed;
      case 'completed':
        return AppTheme.primaryBlue;
      default:
        return AppTheme.primaryBlue;
    }
  }
}
