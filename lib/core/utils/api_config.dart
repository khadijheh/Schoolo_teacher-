class ApiConfig {
 
  static const String baseUrl = 'http://10.0.2.2:8000/api';


  static const String login = '$baseUrl/accounts/teacher-login/';
  static const String sendOtp = '$baseUrl/accounts/send-otp/';
  static const String verifyOtp = '$baseUrl/accounts/verify-otp/';
  static const String setPassword = '$baseUrl/accounts/set-password/';
  static const String logout = '$baseUrl/accounts/logout/';
  
 
  static const String registerTeacher = '$baseUrl/accounts/register-teacher/';
 
  
  // static const String teacherProfile = '$baseUrl/accounts/teacher-profile/';
  // static const String changePassword = '$baseUrl/accounts/change-password/';
}

class AppConstants {
  static const String tokenKey = 'auth_token';
  static const String userTypeKey = 'user_type';
  static const String userIdKey = 'user_id'; 
}