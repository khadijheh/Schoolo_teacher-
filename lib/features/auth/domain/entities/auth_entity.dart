
class TeacherEntity {
  final String phoneNumber;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? specialization;
  final bool isVerified;

  TeacherEntity({
    required this.phoneNumber,
    this.password,
    this.firstName,
    this.lastName,
    this.specialization,
    this.isVerified = false,
  });
}
// class LogoutEntity {
//   final String message;

//   LogoutEntity({required this.message});

//   factory LogoutEntity.fromJson(Map<String, dynamic> json) {
//     return LogoutEntity(
//       message: json['detail'] ?? 'Logged out successfully',
//     );
//   }
