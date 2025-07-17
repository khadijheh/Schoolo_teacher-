import 'package:schoolo_teacher/core/error/exception.dart';
import 'package:schoolo_teacher/features/auth/data/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(TokenModel token);
  Future<TokenModel?> getToken();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  @override
  Future<void> cacheToken(TokenModel token) async {
    try {
      await sharedPreferences.setString('access_token', token.access);
      await sharedPreferences.setString('refresh_token', token.refresh);
      await sharedPreferences.setInt('user_id', token.userId);
      await sharedPreferences.setString('phone_number', token.phoneNumber);
      await sharedPreferences.setString('user_role', token.userRole);
    } catch (e) {
      throw CacheException(message: 'Failed to cache token: ${e.toString()}');
    }
  }

  @override
  Future<TokenModel?> getToken() async {
    try {
      final access = sharedPreferences.getString('access_token');
      if (access == null) return null;

      return TokenModel(
        sharedPreferences.getString('phone_number') ?? "",
        sharedPreferences.getString('user_role') ?? "",
        access: access,
        refresh: sharedPreferences.getString('refresh_token') ?? "",
        userId: sharedPreferences.getInt('user_id') ?? 0,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to get token: ${e.toString()}');
    }
  }

 @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove('access_token');
      await sharedPreferences.remove('refresh_token');
      await sharedPreferences.remove('user_id');
      await sharedPreferences.remove('phone_number');
      await sharedPreferences.remove('user_role');
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: ${e.toString()}');
    }
  }
}
