import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/error/failure.dart';
import 'package:schoolo_teacher/core/network/dio_client.dart';
import 'package:schoolo_teacher/core/utils/api_config.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, TokenModel>> login(LoginModel loginModel);
  Future<Either<Failure, void>> sendOtp(String phoneNumber);
  Future<Either<Failure, void>> verifyOtp(
    String phoneNumber,
    String otp,
    String purpose,
  );
  Future<Either<Failure, TokenModel>> resetPassword(
    String phoneNumber,
    String newPassword,
    String confirmPassword,
  );
  // Future<void> logout(String refreshToken);
  // Future<Either<Failure, void>> completeProfile(TeacherModel registerModel);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});
  @override
  Future<Either<Failure, TokenModel>> login(LoginModel loginModel) async {
    try {
      final response = await dioClient.post(
        ApiConfig.login,
        loginModel.toJson(),
      );

      if (response.data is! Map<String, dynamic>) {
        return Left(ServerFailure('Invalid response format'));
      }
      debugPrint('Parsed token: ${TokenModel.fromJson(response.data)}');
      return Right(TokenModel.fromJson(response.data));
    } on DioException catch (e) {
      final error = e.response?.data?['message'] ?? e.message;
      return Left(ServerFailure(error ?? 'Login failed'));
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp(String phoneNumber) async {
    try {
      await dioClient.post(ApiConfig.sendOtp, {'phone_number': phoneNumber});
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(
    String phoneNumber,
    String otp,
    String purpose,
  ) async {
    try {
      final response = await dioClient.post(ApiConfig.verifyOtp, {
        'phone_number': phoneNumber,
        'otp_code': otp,
        'purpose': purpose,
      });
     log(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(null);
      } else {
        final errorMsg = ' Oops....Verification failed .';
        return Left(ServerFailure(errorMsg));
      }
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.response?.data?['message'] ?? e.message ?? 'Network error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, TokenModel>> resetPassword(
    String phoneNumber,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      final response = await dioClient.post(ApiConfig.setPassword, {
        'phone_number': phoneNumber,
        'new_password': newPassword,
        "confirm_password": confirmPassword,
      });

      debugPrint('API Response: ${response.data}');
      if (response.data is! Map<String, dynamic>) {
        return Left(ServerFailure('Invalid response format'));
      }

      return Right(TokenModel.fromJson(response.data));
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      return Left(ServerFailure(errorMessage));
    }
  }

  String _extractErrorMessage(DioException e) {
    return e.response?.data?['detail'] ??
        e.response?.data?['message'] ??
        e.response?.data?.toString() ??
        e.message ??
        'Unknown error occurred';
  }

//   @override
//  Future<void> logout(String refreshToken) async {
//     await dioClient.post(ApiConfig.logout, {'refresh': refreshToken});
//   }
}
