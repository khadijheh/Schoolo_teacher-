// مصدر البيانات البعيدة للبروفايل
import 'package:schoolo_teacher/core/network/dio_client.dart';
import 'package:schoolo_teacher/features/profile/data/models/teacher_model.dart';

abstract class TeacherProfileRemoteDataSource {
  Future<TeacherModelP> getTeacherProfile(String teacherId);
  Future<void> updateTeacherProfile(TeacherModelP teacher);
}

class TeacherProfileRemoteDataSourceImpl implements TeacherProfileRemoteDataSource {
  final DioClient dioClient;

  TeacherProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<TeacherModelP> getTeacherProfile(String teacherId) async {
    final response = await dioClient.get('/teachers/$teacherId');
    return TeacherModelP.fromJson(response.data['data']);
  }

  @override
  Future<void> updateTeacherProfile(TeacherModelP teacher) async {
    await dioClient.put('/teachers/${teacher.id}',  teacher.toJson());
  }
}