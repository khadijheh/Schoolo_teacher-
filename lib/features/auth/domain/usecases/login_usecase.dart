import 'package:dartz/dartz.dart';
import 'package:schoolo_teacher/core/error/failure.dart';
import 'package:schoolo_teacher/features/auth/data/models/auth_model.dart';
import 'package:schoolo_teacher/features/auth/domain/repositories/auth_repo.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

   Future<Either<Failure, TokenModel>> call(LoginModel loginModel) async {
    return await repository.login(loginModel);
  }
}