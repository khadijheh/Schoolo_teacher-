import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:schoolo_teacher/core/error/exception.dart';
import 'package:schoolo_teacher/core/error/failure.dart';
import 'package:schoolo_teacher/features/auth/data/datasource/auth_api_service.dart';
import 'package:schoolo_teacher/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:schoolo_teacher/features/auth/domain/repositories/auth_repo.dart';

import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<Either<Failure, TokenModel>> login(LoginModel loginModel) async {
    try {
      final result = await remoteDataSource.login(loginModel);
      return result.fold((failure) => Left(failure), (tokenModel) async {
        try {
          await localDataSource.cacheToken(tokenModel);
          return Right(tokenModel);
        } catch (e) {
          return Left(CacheFailure('Failed to cache token'));
        }
      });
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token as String?);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp(String phoneNumber) async {
    try {
      final result = await remoteDataSource.sendOtp(phoneNumber);
      return result.fold((failure) => Left(failure), (_) => const Right(null));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(
    String phoneNumber,
    String otp,
    String purpose,
  ) async {
    try {
      final result = await remoteDataSource.verifyOtp(
        phoneNumber,
        otp,
        purpose,
      );
      return result.fold((failure) => Left(failure), (_) => const Right(null));
    } catch (e) {
      return Left(ServerFailure('Failed to verify OTP: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, TokenModel>> resetPassword(
    String phoneNumber,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      final response = await remoteDataSource.resetPassword(
        phoneNumber,
        newPassword,
        confirmPassword,
      );

      return response.fold((failure) => Left(failure), (tokenModel) async {
        await localDataSource.cacheToken(tokenModel);
        return Right(tokenModel);
      });
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message'] ??
          e.response?.data?['detail'] ??
          e.message ??
          'Password reset failed';
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

}
// Future<Either<Failure, void>> logout(String refreshToken) async {
//   try {
//     await remoteDataSource.logout(refreshToken);
//     await localDataSource.clearCache();
//     return const Right(null);
//   } on ServerException catch (e) {
//     return Left(ServerFailure(e.message));
//   }
// }
  // @override
  // Future<Either<Failure, void>> completeProfile(TeacherModel teacher) async {
  //   try {
  //     final result = await remoteDataSource.completeProfile(teacher);
  //     return result.fold((failure) => Left(failure), (_) => const Right(null));
  //   } catch (e) {
  //     // return Left(ServerFailure('Unexpected error: ${e.toString()}'));
  //   }
  // }

