// تنفيذ واجهة TeacherProfileRepository
import 'package:schoolo_teacher/features/profile/data/datasource/teacher_profile_local_datasource..dart';
import 'package:schoolo_teacher/features/profile/data/datasource/teacher_profile_remote_datasource.dart';
import 'package:schoolo_teacher/features/profile/data/models/teacher_model.dart';
import 'package:schoolo_teacher/features/profile/domain/entities/teacher_entity.dart';
import 'package:schoolo_teacher/features/profile/domain/repo/teacher_repository.dart';

class TeacherProfileRepositoryImpl implements TeacherProfileRepository {
  final TeacherProfileRemoteDataSource remoteDataSource;
  final TeacherProfileLocalDataSource localDataSource;

  TeacherProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<TeacherEntityProfile> getTeacherProfile(String teacherId) async {
    try {
      final teacher = await remoteDataSource.getTeacherProfile(teacherId);
      await localDataSource.cacheTeacherProfile(teacher);
      return teacher;
    } catch (e) {
      final cachedTeacher = await localDataSource.getCachedTeacherProfile();
      if (cachedTeacher != null) {
        return cachedTeacher;
      }
      rethrow;
    }
  }

  @override
  Future<void> updateTeacherProfile(TeacherEntityProfile teacher) async {
    if (teacher is TeacherModelP) {
      await remoteDataSource.updateTeacherProfile(teacher);
      await localDataSource.cacheTeacherProfile(teacher);
    } else {
      throw Exception('Invalid teacher type');
    }
  }

  @override
  Future<void> cacheTeacherProfile(TeacherEntityProfile teacher) async {
    if (teacher is TeacherModelP) {
      await localDataSource.cacheTeacherProfile(teacher);
    }
  }

  @override
  Future<TeacherEntityProfile?> getCachedTeacherProfile() async {
    return await localDataSource.getCachedTeacherProfile();
  }
}