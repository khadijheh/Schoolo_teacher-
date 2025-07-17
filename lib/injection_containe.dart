import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:schoolo_teacher/features/auth/data/datasource/auth_api_service.dart';
import 'package:schoolo_teacher/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:schoolo_teacher/features/auth/data/repository/auth_repo_impl.dart';
import 'package:schoolo_teacher/features/auth/domain/repositories/auth_repo.dart';
import 'package:schoolo_teacher/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:schoolo_teacher/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:schoolo_teacher/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:schoolo_teacher/features/profile/data/datasource/teacher_profile_local_datasource..dart';
import 'package:schoolo_teacher/features/profile/data/datasource/teacher_profile_remote_datasource.dart';
import 'package:schoolo_teacher/features/profile/data/repo/teacher_profile_repository_impl.dart';
import 'package:schoolo_teacher/features/profile/domain/repo/teacher_repository.dart';
import 'package:schoolo_teacher/features/profile/domain/usecases/get_teacher_profile.dart';
import 'package:schoolo_teacher/features/profile/domain/usecases/update_teacher_profile.dart';
import 'package:schoolo_teacher/features/profile/presentation/bloc/teacher_profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';

import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Dio & DioClient
  getIt.registerLazySingleton(() => Dio()); // Dio فقط مرة واحدة
  getIt.registerLazySingleton(
    () => DioClient(getIt<Dio>()),
  ); // هنا نستخدم Dio المسجل

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () =>
        AuthLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SendOtpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => ResetPasswordUseCase(getIt<AuthRepository>()),
  ); 

  // Bloc
  getIt.registerFactory(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      sendOtpUseCase: getIt<SendOtpUseCase>(),
      verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
    ),
  );
  
// ------------------------ Teacher Profile ------------------------
// Data sources
getIt.registerLazySingleton<TeacherProfileRemoteDataSource>(
  () => TeacherProfileRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
);
getIt.registerLazySingleton<TeacherProfileLocalDataSource>(
  () => TeacherProfileLocalDataSourceImpl(
    sharedPreferences: getIt<SharedPreferences>(),
  ),
);

// Repository
getIt.registerLazySingleton<TeacherProfileRepository>(
  () => TeacherProfileRepositoryImpl(
    remoteDataSource: getIt<TeacherProfileRemoteDataSource>(),
    localDataSource: getIt<TeacherProfileLocalDataSource>(),
  ),
);

// Use cases
getIt.registerLazySingleton<GetTeacherProfile>(
  () => GetTeacherProfile(getIt<TeacherProfileRepository>()),
);
getIt.registerLazySingleton<UpdateTeacherProfile>(
  () => UpdateTeacherProfile(getIt<TeacherProfileRepository>()),
);

// Bloc
getIt.registerFactory(
  () => TeacherProfileBloc(
    getTeacherProfile: getIt<GetTeacherProfile>(),
    updateTeacherProfile: getIt<UpdateTeacherProfile>(),
    // repository: null, // يجب إزالة هذا السطر لأنه غير مستخدم في BLoC
  ),
);

  
}
