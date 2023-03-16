class UserModel {
  String id;
  String? email;
  String? businessName;
  String? businessType;
  String? businessIndustry;

  UserModel({
    required this.id,
    this.email,
    this.businessName,
    this.businessType,
    this.businessIndustry,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        email: json['email'],
        businessName: json['business_name'],
        businessType: json['business_type'],
        businessIndustry: json['business_industry'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'business_name': businessName,
        'business_type': businessType,
        'business_industry': businessIndustry,
      };
}
