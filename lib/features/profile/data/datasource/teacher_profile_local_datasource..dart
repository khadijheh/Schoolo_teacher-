import 'dart:convert';
import 'package:schoolo_teacher/features/profile/data/models/teacher_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TeacherProfileLocalDataSource {
  Future<void> cacheTeacherProfile(TeacherModelP teacher);
  Future<TeacherModelP?> getCachedTeacherProfile();
}

class TeacherProfileLocalDataSourceImpl implements TeacherProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  TeacherProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheTeacherProfile(TeacherModelP teacher) async {
    await sharedPreferences.setString(
      'cached_teacher',
      jsonEncode(teacher.toJson()),
    );
  }

  @override
  Future<TeacherModelP?> getCachedTeacherProfile() async {
    final jsonString = sharedPreferences.getString('cached_teacher');
    if (jsonString != null) {
      return TeacherModelP.fromJson(jsonDecode(jsonString));
    }
    return null;
  }
}