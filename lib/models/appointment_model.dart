class AppointmentModel {
  final String id;
  final String patientName;
  final String patientEmail;
  final String patientPhone;
  final String patientAvatar;
  final String date;
  final String time;
  final String service;
  final String serviceType;
  final String notes;
  final String duration;
  final double consultationFee;
  final String paymentStatus;
  String status;
  final DateTime createdAt;
  final bool isUrgent;
  final String patientAge;
  final String patientGender;
  final String medicalHistory;
  final String fcmToken;

  AppointmentModel({
    required this.id,
    required this.patientName,
    required this.patientEmail,
    required this.patientPhone,
    required this.patientAvatar,
    required this.date,
    required this.time,
    required this.service,
    required this.serviceType,
    required this.notes,
    required this.duration,
    required this.consultationFee,
    required this.paymentStatus,
    required this.status,
    required this.createdAt,
    this.isUrgent = false,
    required this.patientAge,
    required this.patientGender,
    required this.medicalHistory,
    required this.fcmToken,
  });

  AppointmentModel copyWith({
    String? id,
    String? patientName,
    String? patientEmail,
    String? patientPhone,
    String? patientAvatar,
    String? date,
    String? time,
    String? service,
    String? serviceType,
    String? notes,
    String? duration,
    double? consultationFee,
    String? paymentStatus,
    String? status,
    DateTime? createdAt,
    bool? isUrgent,
    String? patientAge,
    String? patientGender,
    String? medicalHistory,
    String? fcmToken,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      patientEmail: patientEmail ?? this.patientEmail,
      patientPhone: patientPhone ?? this.patientPhone,
      patientAvatar: patientAvatar ?? this.patientAvatar,
      date: date ?? this.date,
      time: time ?? this.time,
      service: service ?? this.service,
      serviceType: serviceType ?? this.serviceType,
      notes: notes ?? this.notes,
      duration: duration ?? this.duration,
      consultationFee: consultationFee ?? this.consultationFee,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isUrgent: isUrgent ?? this.isUrgent,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientName': patientName,
      'patientEmail': patientEmail,
      'patientPhone': patientPhone,
      'patientAvatar': patientAvatar,
      'date': date,
      'time': time,
      'service': service,
      'serviceType': serviceType,
      'notes': notes,
      'duration': duration,
      'consultationFee': consultationFee,
      'paymentStatus': paymentStatus,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'isUrgent': isUrgent,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'medicalHistory': medicalHistory,
      'fcmToken': fcmToken,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] ?? '',
      patientName: map['patientName'] ?? '',
      patientEmail: map['patientEmail'] ?? '',
      patientPhone: map['patientPhone'] ?? '',
      patientAvatar: map['patientAvatar'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      service: map['service'] ?? '',
      serviceType: map['serviceType'] ?? '',
      notes: map['notes'] ?? '',
      duration: map['duration'] ?? '30 mins',
      consultationFee: (map['consultationFee'] ?? 0.0).toDouble(),
      paymentStatus: map['paymentStatus'] ?? 'pending',
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      isUrgent: map['isUrgent'] ?? false,
      patientAge: map['patientAge'] ?? '',
      patientGender: map['patientGender'] ?? '',
      medicalHistory: map['medicalHistory'] ?? '',
      fcmToken: map['fcmToken'] ?? '',
    );
  }

  String get displayDate {
    final dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String get displayTime {
    return time;
  }

  bool get isToday {
    final today = DateTime.now();
    final appointmentDate = DateTime.parse(date);
    return today.year == appointmentDate.year && today.month == appointmentDate.month && today.day == appointmentDate.day;
  }

  bool get isUpcoming {
    final now = DateTime.now();
    final appointmentDate = DateTime.parse(date);
    return appointmentDate.isAfter(now);
  }

  String get consultationFeeDisplay {
    return '₹${consultationFee.toStringAsFixed(0)}';
  }

  String get patientInitials {
    final names = patientName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return patientName.length >= 2 ? patientName.substring(0, 2).toUpperCase() : patientName.toUpperCase();
  }
}
