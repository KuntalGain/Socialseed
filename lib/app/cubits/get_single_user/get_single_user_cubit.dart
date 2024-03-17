import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socialseed/domain/entities/user_entity.dart';
import 'package:socialseed/domain/usecases/user/get_single_user_usecase.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUsecase singleUserUsecase;
  GetSingleUserCubit({required this.singleUserUsecase})
      : super(GetSingleUsersInitial());

  Future<void> getSingleUsers({required String uid}) async {
    emit(GetSingleUsersLoading());
    try {
      final streamResponse = singleUserUsecase.call(uid);

      streamResponse.listen((users) {
        emit(GetSingleUsersLoaded(user: users.first));
      });
    } on SocketException catch (_) {
      emit(GetSingleUsersFailure());
    } catch (_) {
      emit(GetSingleUsersFailure());
    }
  }
}
