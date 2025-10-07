class AppointmentModel {
  final int id;
  final String patientName;
  final String date;
  final String time;
  final String service;
  final String status;

  AppointmentModel({required this.id, required this.patientName, required this.date, required this.time, required this.service, required this.status});
}
