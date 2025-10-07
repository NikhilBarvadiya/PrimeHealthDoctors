import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_health_doctors/models/service_model.dart';

class ServicesCtrl extends GetxController {
  var filteredServices = <ServiceModel>[].obs;

  var services = <ServiceModel>[
    ServiceModel(
      id: 1,
      name: 'Cardiology',
      description: 'Comprehensive heart care including diagnosis, treatment, and prevention of cardiovascular diseases.',
      icon: Icons.favorite_rounded,
      isActive: true,
      rate: 1500.0,
    ),
    ServiceModel(
      id: 2,
      name: 'Orthopedics',
      description: 'Specialized care for bones, joints, muscles, and spine conditions and injuries.',
      icon: Icons.accessible_rounded,
      isActive: true,
      rate: 1200.0,
    ),
    ServiceModel(
      id: 3,
      name: 'Neurology',
      description: 'Expert diagnosis and treatment for brain, spinal cord, and nervous system disorders.',
      icon: Icons.psychology_rounded,
      isActive: true,
      rate: 1800.0,
    ),
    ServiceModel(id: 4, name: 'Pediatrics', description: 'Comprehensive healthcare for infants, children, and adolescents up to age 18.', icon: Icons.child_care_rounded, isActive: true, rate: 1000.0),
    ServiceModel(id: 5, name: 'Dermatology', description: 'Skin, hair, and nail care including medical and cosmetic treatments.', icon: Icons.spa_rounded, isActive: false, rate: 900.0),
    ServiceModel(id: 6, name: 'General Checkup', description: 'Routine health assessment and preventive care for overall wellness.', icon: Icons.medical_services_rounded, isActive: true, rate: 500.0),
    ServiceModel(id: 7, name: 'Emergency Care', description: 'Immediate medical attention for urgent health conditions and emergencies.', icon: Icons.emergency_rounded, isActive: true, rate: 2000.0),
    ServiceModel(id: 8, name: 'Physiotherapy', description: 'Rehabilitation and pain management through physical therapy techniques.', icon: Icons.directions_run_rounded, isActive: true, rate: 800.0),
    ServiceModel(
      id: 9,
      name: 'Mental Health',
      description: 'Psychological assessment and therapy for mental wellness and disorders.',
      icon: Icons.self_improvement_rounded,
      isActive: false,
      rate: 1200.0,
    ),
    ServiceModel(id: 10, name: 'Dental Care', description: 'Complete oral health services including cleaning, fillings, and surgery.', icon: Icons.car_repair, isActive: true, rate: 600.0),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    filterServices();
  }

  void filterServices() => filteredServices.assignAll(services);

  void searchServices(String query) {
    if (query.isEmpty) {
      filterServices();
    } else {
      filteredServices.assignAll(services.where((service) => service.name.toLowerCase().contains(query.toLowerCase()) || service.description.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void toggleServiceStatus(int serviceId, bool isActive) {
    int index = services.indexWhere((e) => e.id == serviceId);
    if (index != -1) {
      services[index].isActive = isActive;
    }
    filterServices();
    update();
  }
}
