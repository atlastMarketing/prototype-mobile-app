class UserModel {
  String id;
  String? email;
  String? businessName;
  String? businessType;
  String? businessIndustry;
  String? businessDescription;

  UserModel({
    required this.id,
    this.email,
    this.businessName,
    this.businessType,
    this.businessIndustry,
    this.businessDescription,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      email: json['email'],
      businessName: json['business_name'],
      businessType: json['business_type'],
      businessIndustry: json['business_industry'],
      businessDescription: json['business_description'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'email': email,
        'business_name': businessName,
        'business_type': businessType,
        'business_industry': businessIndustry,
        'business_description': businessDescription,
      };
}
