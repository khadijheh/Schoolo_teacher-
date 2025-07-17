class TeacherEntityProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String specialization;
  final String joinDate;
  final String? imageUrl;

  TeacherEntityProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.joinDate,
    this.imageUrl,
  }); 
  // Override للـ equals و hashCode لمقارنة المعلمين
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeacherEntityProfile &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
