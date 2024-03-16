import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:socialseed/domain/usecases/get_current_uid_usecase.dart';
import 'package:socialseed/domain/usecases/is_signin_usecase.dart';
import 'package:socialseed/domain/usecases/sign_out_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignOutUsecase signOutUsecase;
  final GetCurrentUidUsecase getCurrentUidUsecase;
  final IsSignInUsecase isSignInUsecase;

  AuthCubit({
    required this.signOutUsecase,
    required this.getCurrentUidUsecase,
    required this.isSignInUsecase,
  }) : super(AuthInitial());

  Future<void> appStarted(BuildContext context) async {
    try {
      bool isSignIn = await isSignInUsecase.call();

      if (isSignIn == true) {
        final uid = await getCurrentUidUsecase.call();
        emit(Authenticated(uid: uid));
      } else {
        emit(NotAuthenticated());
      }
    } catch (_) {
      emit(NotAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = await getCurrentUidUsecase.call();
      emit(Authenticated(uid: uid));
    } catch (_) {
      emit(NotAuthenticated());
    }
  }

  Future<void> logout() async {
    try {
      await signOutUsecase.call();
      emit(NotAuthenticated());
    } catch (_) {
      emit(NotAuthenticated());
    }
  }
}
