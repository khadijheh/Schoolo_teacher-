import 'package:schoolo_teacher/features/auth/domain/entities/auth_entity.dart';

class LoginModel {
  final String phoneNumber;
  final String password;

  LoginModel({required this.phoneNumber, required this.password});

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'password': password,
  };
}

class TokenModel {
  final String access;
  final String refresh;
  final int userId;
  final String phoneNumber; // إضافة هذا الحقل
  final String userRole;   

  TokenModel(this.phoneNumber, this.userRole, {
    required this.access,
    required this.refresh,
    required this.userId,
  });

 factory TokenModel.fromJson(Map<String, dynamic> json) {
  return TokenModel(
     json['phone_number'] as String,
    json['user_role'] as String,
    access: json['access_token'] as String,
    refresh: json['refresh_token'] as String,
    userId: json['user_id'] as int,
  );
}
}
class VerifyOtpModel {
  final String phoneNumber;
  final String otp;
  final String purpose; // 'password_reset' أو 'phone_verification'

  VerifyOtpModel({
    required this.phoneNumber,
    required this.otp,
    required this.purpose,
  });

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'otp_code': otp,
    'purpose': purpose,
  };
}
class TeacherModel extends TeacherEntity {
  TeacherModel({
    required super.phoneNumber,
    super.password,
    super.firstName,
    super.lastName,
    super.specialization,
    super.isVerified,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      phoneNumber: json['phone_number'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      specialization: json['specialization'],
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'first_name': firstName,
      'last_name': lastName,
      'specialization': specialization,
      'is_verified': isVerified,
    };
  }
}