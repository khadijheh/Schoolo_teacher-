// حالات BLoC للبروفايل
import 'package:schoolo_teacher/features/profile/domain/entities/teacher_entity.dart';

abstract class TeacherProfileState {
  const TeacherProfileState();
}

class TeacherProfileInitial extends TeacherProfileState {}

class TeacherProfileLoading extends TeacherProfileState {}

class TeacherProfileLoaded extends TeacherProfileState {
  final TeacherEntityProfile teacher;

  const TeacherProfileLoaded(this.teacher);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeacherProfileLoaded &&
          runtimeType == other.runtimeType &&
          teacher == other.teacher;

  @override
  int get hashCode => teacher.hashCode;
}

class TeacherProfileUpdated extends TeacherProfileState {}

class TeacherProfileError extends TeacherProfileState {
  final String message;

  const TeacherProfileError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeacherProfileError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}