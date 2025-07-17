part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  const LoginEvent({required this.phoneNumber, required this.password});

  @override
  List<Object> get props => [phoneNumber, password];
}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;

  const SendOtpEvent(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}
class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String otp;
  final String purpose; 

  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.otp,
    required this.purpose,
  });

  @override
  List<Object> get props => [phoneNumber, otp, purpose];
}

class ResetPasswordEvent extends AuthEvent {
  final String phoneNumber;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordEvent({
    required this.phoneNumber,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [phoneNumber, newPassword, confirmPassword];
}
class LogoutRequested extends AuthEvent {
  final String refreshToken;

  const LogoutRequested({required this.refreshToken});

  @override
  List<Object> get props => [refreshToken];
}

