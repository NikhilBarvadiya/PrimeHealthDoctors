class AppointmentModel {
  final String id;
  final String bookingId;
  final String patientId;
  final String patientName;
  final String? patientEmail;
  final String? patientPhone;
  final String? patientAvatar;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String? serviceName;
  final String? serviceId;
  final String? doctorId;
  final String consultationType;
  final String? notes;
  final String? duration;
  final double amount;
  final String paymentStatus;
  String status;
  final DateTime createdAt;
  final bool isUrgent;
  final String? patientAge;
  final String? patientGender;
  final String? medicalHistory;
  final String? fcmToken;

  AppointmentModel({
    required this.id,
    required this.bookingId,
    required this.patientId,
    required this.patientName,
    this.patientEmail,
    this.patientPhone,
    this.patientAvatar,
    required this.appointmentDate,
    required this.appointmentTime,
    this.serviceName,
    this.serviceId,
    this.doctorId,
    required this.consultationType,
    this.notes,
    this.duration,
    required this.amount,
    required this.paymentStatus,
    required this.status,
    required this.createdAt,
    this.isUrgent = false,
    this.patientAge,
    this.patientGender,
    this.medicalHistory,
    this.fcmToken,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    dynamic patientData = map['patientId'] ?? {};
    String patientName = '', patientId = '';
    if (patientData is Map<String, dynamic>) {
      patientName = patientData['name']?.toString() ?? 'Patient';
      patientId = patientData['_id']?.toString() ?? patientData['id']?.toString() ?? '';
    } else {
      patientName = 'Patient';
      patientId = patientData?.toString() ?? '';
    }
    dynamic serviceData = map['serviceId'] ?? {};
    String serviceName = '';
    if (serviceData is Map<String, dynamic>) {
      serviceName = serviceData['name']?.toString() ?? 'Service';
    } else {
      serviceName = 'Service';
    }
    DateTime appointmentDate;
    try {
      appointmentDate = DateTime.parse(map['appointmentDate']?.toString() ?? DateTime.now().toString());
    } catch (e) {
      appointmentDate = DateTime.now();
    }

    return AppointmentModel(
      id: map['_id']?.toString() ?? map['id']?.toString() ?? '',
      bookingId: map['bookingId']?.toString() ?? '',
      patientId: patientId,
      patientName: patientName,
      patientEmail: map['patientEmail']?.toString(),
      patientPhone: map['patientPhone']?.toString(),
      patientAvatar: map['patientAvatar']?.toString(),
      appointmentDate: appointmentDate,
      appointmentTime: map['appointmentTime']?.toString() ?? '',
      serviceName: serviceName,
      serviceId: map['serviceId']?.toString(),
      doctorId: map['doctorId']?.toString(),
      consultationType: map['consultationType']?.toString() ?? 'in-person',
      notes: map['notes']?.toString(),
      duration: map['duration']?.toString() ?? '30 mins',
      amount: double.tryParse(map['amount'].toString()) ?? 0.0,
      paymentStatus: map['paymentStatus']?.toString() ?? 'pending',
      status: map['status']?.toString() ?? 'scheduled',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'].toString()) : DateTime.now(),
      isUrgent: map['isUrgent'] ?? false,
      patientAge: map['patientAge']?.toString(),
      patientGender: map['patientGender']?.toString(),
      medicalHistory: map['medicalHistory']?.toString(),
      fcmToken: map['fcmToken']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'patientId': patientId,
      'patientName': patientName,
      'appointmentDate': appointmentDate.toIso8601String(),
      'appointmentTime': appointmentTime,
      'serviceName': serviceName,
      'consultationType': consultationType,
      'amount': amount,
      'paymentStatus': paymentStatus,
      'status': status,
    };
  }

  String get displayDate {
    try {
      return '${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}';
    } catch (e) {
      return 'Date not available';
    }
  }

  String get displayTime {
    try {
      if (appointmentTime.contains('AM') || appointmentTime.contains('PM')) {
        return appointmentTime;
      }
      final timeParts = appointmentTime.split(':');
      if (timeParts.length >= 2) {
        int hour = int.tryParse(timeParts[0]) ?? 0;
        int minute = int.tryParse(timeParts[1]) ?? 0;
        String period = hour >= 12 ? 'PM' : 'AM';
        hour = hour % 12;
        hour = hour == 0 ? 12 : hour;
        return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
      }
      return appointmentTime;
    } catch (e) {
      return appointmentTime;
    }
  }

  String get consultationFeeDisplay {
    return amount.toStringAsFixed(0);
  }

  String get patientInitials {
    final names = patientName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return patientName.length >= 2 ? patientName.substring(0, 2).toUpperCase() : patientName.toUpperCase();
  }

  bool get isToday {
    final today = DateTime.now();
    return today.year == appointmentDate.year && today.month == appointmentDate.month && today.day == appointmentDate.day;
  }

  String get statusDisplay {
    final statusMap = {'scheduled': 'Scheduled', 'confirmed': 'Confirmed', 'completed': 'Completed', 'cancelled': 'Cancelled', 'rescheduled': 'Rescheduled', 'no-show': 'No Show'};
    return statusMap[status] ?? status;
  }
}
