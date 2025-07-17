// أحداث BLoC للبروفايل
import 'package:schoolo_teacher/features/profile/domain/entities/teacher_entity.dart';

abstract class TeacherProfileEvent {
  const TeacherProfileEvent();
}

class LoadTeacherProfile extends TeacherProfileEvent {
  final String teacherId;

  const LoadTeacherProfile(this.teacherId);
}

class UpdateTeacherProfileEvent extends TeacherProfileEvent {
  final TeacherEntityProfile teacher;

  const UpdateTeacherProfileEvent(this.teacher);
}

class ClearTeacherProfileCache extends TeacherProfileEvent {}