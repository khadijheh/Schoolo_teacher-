import 'package:dartz/dartz.dart';
import 'package:schoolo_teacher/core/error/failure.dart';
import 'package:schoolo_teacher/features/auth/data/models/auth_model.dart';
import 'package:schoolo_teacher/features/auth/domain/repositories/auth_repo.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, TokenModel>> call(
    String phoneNumber,
    String newPassword,
    String confirmPassword,
  ) async {
    return await repository.resetPassword(
      phoneNumber,
      newPassword,
      confirmPassword,
    );
  }
}