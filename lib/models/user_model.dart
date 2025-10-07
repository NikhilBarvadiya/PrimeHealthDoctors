class UserModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String password;
  final String specialty;
  final int experienceYears;
  final String clinicName;
  final String clinicAddress;
  final String referralCode;
  final String ownReferralCode;
  final String registrationDate;
  final String fcmToken;


  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
    required this.specialty,
    required this.experienceYears,
    required this.clinicName,
    required this.clinicAddress,
    required this.referralCode,
    required this.ownReferralCode,
    required this.registrationDate,
    required this.fcmToken,
  });
}
