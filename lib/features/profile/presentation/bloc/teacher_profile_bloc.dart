// BLoC لإدارة حالة البروفايل
import 'package:bloc/bloc.dart';

import 'package:schoolo_teacher/features/profile/domain/usecases/get_teacher_profile.dart';
import 'package:schoolo_teacher/features/profile/domain/usecases/update_teacher_profile.dart';
import 'package:schoolo_teacher/features/profile/presentation/bloc/teacher_profile_event.dart';
import 'package:schoolo_teacher/features/profile/presentation/bloc/teacher_profile_state.dart';

class TeacherProfileBloc extends Bloc<TeacherProfileEvent, TeacherProfileState> {
  final GetTeacherProfile getTeacherProfile;
  final UpdateTeacherProfile updateTeacherProfile;
  // final TeacherProfileRepository repository;

  TeacherProfileBloc({
    required this.getTeacherProfile,
    required this.updateTeacherProfile,
    // required this.repository,
  }) : super(TeacherProfileInitial()) {
    on<LoadTeacherProfile>(_onLoadProfile);
    on<UpdateTeacherProfileEvent>(_onUpdateProfile);
    on<ClearTeacherProfileCache>(_onClearCache);
  }

  Future<void> _onLoadProfile(
    LoadTeacherProfile event,
    Emitter<TeacherProfileState> emit,
  ) async {
    emit(TeacherProfileLoading());
    try {
      final teacher = await getTeacherProfile(event.teacherId);
      emit(TeacherProfileLoaded(teacher));
    } catch (e) {
      emit(TeacherProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateTeacherProfileEvent event,
    Emitter<TeacherProfileState> emit,
  ) async {
    try {
      await updateTeacherProfile(event.teacher);
      emit(TeacherProfileUpdated());
      add(LoadTeacherProfile(event.teacher.id));
    } catch (e) {
      emit(TeacherProfileError('Failed to update profile: ${e.toString()}'));
    }
  }

  Future<void> _onClearCache(
    ClearTeacherProfileCache event,
    Emitter<TeacherProfileState> emit,
  ) async {
    // await repository.cacheTeacherProfile(
    //   TeacherEntityProfile(
    //     id: '',
    //     name: '',
    //     email: '',
    //     phone: '',
    //     specialization: '',
    //     joinDate: '',
    //   ),
    // );
  }
}