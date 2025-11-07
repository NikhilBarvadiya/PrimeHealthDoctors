class PatientModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? bloodGroup;
  final String? gender;
  final String? profileImage;

  PatientModel({required this.id, required this.name, this.email, this.phone, this.bloodGroup, this.gender, this.profileImage});

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['_id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString(),
      phone: map['phone']?.toString(),
      bloodGroup: map['bloodGroup']?.toString(),
      gender: map['gender']?.toString(),
      profileImage: map['profileImage']?.toString(),
    );
  }
}
