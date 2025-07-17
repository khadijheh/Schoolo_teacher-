// واجهة الريبوزيتوري التي تحدد العمليات المتاحة للبروفايل
import 'package:schoolo_teacher/features/profile/domain/entities/teacher_entity.dart';

abstract class TeacherProfileRepository {
  Future<TeacherEntityProfile> getTeacherProfile(String teacherId);
  Future<void> updateTeacherProfile(TeacherEntityProfile teacher);
  Future<void> cacheTeacherProfile(TeacherEntityProfile teacher);
  Future<TeacherEntityProfile?> getCachedTeacherProfile();
}