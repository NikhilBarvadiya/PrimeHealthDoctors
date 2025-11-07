class UserModel {
  String id;
  String name;
  String email;
  String mobile;
  String license;
  String specialty;
  String services;
  String bio;
  String profileImage;
  String logo;
  Pricing pricing;
  List<Certification> certifications;
  bool isActive;
  DateTime createdAt;

  UserModel({
    this.id = '',
    this.name = '',
    this.email = '',
    this.mobile = '',
    this.license = '',
    this.specialty = '',
    this.services = '',
    this.bio = '',
    this.profileImage = '',
    this.logo = '',
    Pricing? pricing,
    List<Certification>? certifications,
    this.isActive = true,
    DateTime? createdAt,
  }) : pricing = pricing ?? Pricing(),
       certifications = certifications ?? [],
       createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobileNo'] ?? '',
      license: json['license'] ?? '',
      specialty: json['specialty'] is Map ? json['specialty']['name'] ?? '' : json['specialty']?.toString() ?? '',
      services: json['services'] is Map ? json['services']['name'] ?? '' : json['services']?.toString() ?? '',
      bio: json['bio'] ?? '',
      profileImage: json['profileImage'] ?? '',
      logo: json['logo'] ?? '',
      pricing: json['pricing'] != null ? Pricing.fromJson(json['pricing']) : Pricing(),
      certifications: json['certifications'] != null ? List<Certification>.from(json['certifications'].map((x) => Certification.fromJson(x))) : [],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobileNo': mobile,
      'license': license,
      'specialty': specialty,
      'services': services,
      'bio': bio,
      'profileImage': profileImage,
      'logo': logo,
      'pricing': pricing.toJson(),
      'certifications': certifications.map((x) => x.toJson()).toList(),
      'isActive': isActive,
    };
  }
}

class Pricing {
  int consultationFee;
  int followUpFee;

  Pricing({this.consultationFee = 500, this.followUpFee = 300});

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(consultationFee: int.tryParse(json['consultationFee'].toString()) ?? 500, followUpFee: int.tryParse(json['followUpFee'].toString()) ?? 300);
  }

  Map<String, dynamic> toJson() {
    return {'consultationFee': consultationFee, 'followUpFee': followUpFee};
  }
}

class Certification {
  String name;
  String document;
  String issuedBy;
  DateTime issueDate;

  Certification({required this.name, required this.document, required this.issuedBy, required this.issueDate});

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      name: json['name'] ?? '',
      document: json['document'] ?? '',
      issuedBy: json['issuedBy'] ?? '',
      issueDate: json['issueDate'] != null ? DateTime.parse(json['issueDate']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'document': document, 'issuedBy': issuedBy, 'issueDate': issueDate.toIso8601String()};
  }
}
