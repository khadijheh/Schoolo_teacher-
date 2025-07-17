part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final TokenModel token;

  const AuthSuccess(this.token);

  @override
  List<Object> get props => [token];
}

class OtpSentState extends AuthState {
  final String phoneNumber;

  const OtpSentState(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class OtpVerifiedState extends AuthState {
  final String phoneNumber;
  final String otp;
  final String purpose;

  const OtpVerifiedState(this.phoneNumber, this.otp, this.purpose);

  @override
  List<Object> get props => [phoneNumber, otp, purpose];
}

class PhoneAlreadyVerified extends AuthState {
  final String phoneNumber;
  const PhoneAlreadyVerified(this.phoneNumber);
}

class PasswordResetState extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
class LogoutInProgress extends AuthState {}

// class LogoutSuccess extends AuthState {
//   final LogoutEntity logoutEntity;

//   const LogoutSuccess({required this.logoutEntity});

//   @override
//   List<Object> get props => [logoutEntity];
// }

class LogoutFailure extends AuthState {
  final Failure failure;

  const LogoutFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}


