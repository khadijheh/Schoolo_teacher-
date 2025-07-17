import 'package:dartz/dartz.dart';
import 'package:schoolo_teacher/core/error/failure.dart';
import 'package:schoolo_teacher/features/auth/domain/repositories/auth_repo.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String phoneNumber,
    required String otp,
    required String purpose,
  }) async {
    return await repository.verifyOtp(
      phoneNumber,
otp,
       purpose,
    );
  }
}