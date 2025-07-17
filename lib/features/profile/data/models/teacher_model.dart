// نموذج بيانات المعلم لطبقة البيانات
import 'package:schoolo_teacher/features/profile/domain/entities/teacher_entity.dart';

class TeacherModelP extends TeacherEntityProfile {
   TeacherModelP({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.specialization,
    required super.joinDate,
    super.imageUrl,
  });

  // تحويل من JSON إلى TeacherModel
  factory TeacherModelP.fromJson(Map<String, dynamic> json) {
    return TeacherModelP(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      specialization: json['specialization'] as String,
      joinDate: json['joinDate'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  // تحويل TeacherModel إلى JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'specialization': specialization,
        'joinDate': joinDate,
        'imageUrl': imageUrl,
      };
}