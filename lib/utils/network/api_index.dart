class APIIndex {
  /// Auth
  static const String register = 'register'; // done
  static const String specialities = 'specialities'; // done
  static const String login = 'login'; // done
  static const String sendOTP = 'send-otp'; // done
  static const String verifyOTP = 'verify-otp'; // done
  static const String getProfile = 'get-profile';
  static const String updateProfile = 'update-profile';
  static const String updatePassword = 'doctor/change-password';
  static const String updateWorkingDays = 'doctor/update-working-days';

  /// Service
  static const String doctorServices = 'doctor/services';
  static const String toggleService = 'doctor/toggle-service';

  /// Equipment
  static const String doctorEquipment = 'doctor/equipment';
  static const String toggleEquipment = 'doctor/toggle-equipment';

  /// Appointments
  static const String getAppointments = 'doctor/appointments/get';
  static const String requestsAccept = 'doctor/requests/accept';
  static const String requestsCancel = 'doctor/requests/cancel';
  static const String completeAppointment = 'doctor/appointments/complete';
}
