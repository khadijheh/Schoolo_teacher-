import 'package:dartz/dartz.dart';
import 'package:schoolo_teacher/core/error/failure.dart';
import 'package:schoolo_teacher/features/auth/data/models/auth_model.dart';
// import 'package:schoolo_teacher/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
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
  Future<Either<Failure, String?>> getToken();

  // Future<void> logout(String refreshToken);
}
