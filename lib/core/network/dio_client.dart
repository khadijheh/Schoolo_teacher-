import 'package:dio/dio.dart';
import 'package:schoolo_teacher/core/error/exception.dart';
import 'package:schoolo_teacher/core/utils/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio _dio;

  DioClient([Dio? dio]) : _dio = Dio() {
    // إعدادات أساسية
    _dio.options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      followRedirects: true,
      maxRedirects: 5,
      validateStatus: (status) => status! < 500,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    LogInterceptor(request: true, responseBody: true, error: true);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(AppConstants.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(path, queryParameters: queryParams);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(String path, dynamic data) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // دالة مساعدة لمعالجة الأخطاء
  ServerException _handleError(DioException e) {
    final errorData = e.response?.data;
    String errorMessage = 'حدث خطأ غير متوقع';

    if (errorData is Map<String, dynamic>) {
      errorMessage =
          errorData['detail'] ?? errorData['message'] ?? errorData.toString();
    } else if (e.message != null) {
      errorMessage = e.message!;
    }

    return ServerException(message: errorMessage);
  }
}
