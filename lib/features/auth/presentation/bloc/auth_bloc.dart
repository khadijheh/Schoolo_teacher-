import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/error/failure.dart';
import 'package:schoolo_teacher/features/auth/data/models/auth_model.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String? phoneNumber;
  final LoginUseCase loginUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  // final LogoutUseCase logoutUseCase;
  AuthBloc({
    required this.loginUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
    // required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<SendOtpEvent>(_onSendOtpEvent);
    on<VerifyOtpEvent>(_onVerifyOtpEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
    // on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(
      LoginModel(phoneNumber: event.phoneNumber, password: event.password),
    );

    result.fold(
      (failure) {
        String errorMessage = _mapErrorToMessage(failure);
        debugPrint('Login failed: $errorMessage');
        emit(AuthInitial());
        emit(AuthError(errorMessage));
      },
      (token) {
        debugPrint('Login success for ${event.phoneNumber}');
        emit(AuthSuccess(token));
      },
    );
  }

  String _mapErrorToMessage(Failure failure) {
    return "PhoneNumber or Password are not correct";
  }

  Future<void> _onSendOtpEvent(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await sendOtpUseCase(event.phoneNumber);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(OtpSentState(event.phoneNumber)),
    );
  }

  Future<void> _onVerifyOtpEvent(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    phoneNumber = event.phoneNumber;
    emit(AuthLoading());
    final result = await verifyOtpUseCase(
      phoneNumber: event.phoneNumber,
      otp: event.otp,
      purpose: event.purpose,
    );

    result.fold(
      (failure) {
        if (failure.message.contains('تم تأكيد رقم الهاتف')) {
          emit(PhoneAlreadyVerified(event.phoneNumber));
        } else {
          emit(AuthInitial());
          emit(AuthError(failure.message));
        }
      },
      (_) =>
          emit(OtpVerifiedState(event.phoneNumber, event.otp, event.purpose)),
    );
  }

  Future<void> _onResetPasswordEvent(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await resetPasswordUseCase(
      event.phoneNumber,
      event.newPassword,
      event.confirmPassword,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (token) => emit(AuthSuccess(token)),
    );
  }
  // Future<void> _onLogoutRequested(
  //   LogoutRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(LogoutInProgress());
  //   final result = await logoutUseCase(event.refreshToken);

  //   result.fold(
  //     (failure) => emit(LogoutFailure(failure: failure)),
  //     (logoutEntity) {
  //       emit(LogoutSuccess(logoutEntity: logoutEntity));
  //       emit(AuthInitial());
  //     },
  //   );
  // }
}
