// حالة استخدام لتحديث بيانات المعلم
import 'package:schoolo_teacher/features/profile/domain/entities/teacher_entity.dart';
import 'package:schoolo_teacher/features/profile/domain/repo/teacher_repository.dart';

class UpdateTeacherProfile {
  final TeacherProfileRepository repository;

  UpdateTeacherProfile(this.repository);

  Future<void> call(TeacherEntityProfile teacher) async {
    await repository.updateTeacherProfile(teacher);
  }
}