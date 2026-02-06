class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? token;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.token,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      token: json['token']?.toString(), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'token': token,
    };
  }
}
