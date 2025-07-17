// حالة استخدام لجلب بيانات المعلم
import 'package:schoolo_teacher/features/profile/domain/entities/teacher_entity.dart';
import 'package:schoolo_teacher/features/profile/domain/repo/teacher_repository.dart';

class GetTeacherProfile {
  final TeacherProfileRepository repository;

  GetTeacherProfile(this.repository);

  Future<TeacherEntityProfile> call(String teacherId) async {
    return await repository.getTeacherProfile(teacherId);
  }
}