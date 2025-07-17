import 'package:dartz/dartz.dart';
import 'package:schoolo_teacher/core/error/failure.dart';
import 'package:schoolo_teacher/features/auth/domain/repositories/auth_repo.dart';

class SendOtpUseCase {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  Future<Either<Failure, void>> call(String phoneNumber) async {
    return await repository.sendOtp(phoneNumber);
  }
}