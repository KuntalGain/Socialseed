import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socialseed/domain/entities/user_entity.dart';
import 'package:socialseed/domain/usecases/sign_in_usecase.dart';
import 'package:socialseed/domain/usecases/sign_up_usecase.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInUsecase signInUsecase;
  final SignUpUsecase signUpUsecase;

  CredentialCubit({required this.signInUsecase, required this.signUpUsecase})
      : super(CredentialInitial());

  Future<void> signInUser(
      {required String email, required String password}) async {
    emit(CredentialLoading());
    try {
      await signInUsecase.call(UserEntity(email: email, password: password));
      emit(CredentialSuccess());
    } on SocketException {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> signUpUser({required UserEntity user}) async {
    emit(CredentialLoading());
    try {
      await signUpUsecase.call(user);
      emit(CredentialSuccess());
    } on SocketException {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }
}
