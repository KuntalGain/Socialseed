part of 'get_single_user_cubit.dart';

abstract class GetSingleUserState extends Equatable {
  const GetSingleUserState();
}

class GetSingleUsersInitial extends GetSingleUserState {
  @override
  List<Object> get props => [];
}

class GetSingleUsersLoading extends GetSingleUserState {
  @override
  List<Object> get props => [];
}

class GetSingleUsersLoaded extends GetSingleUserState {
  final UserEntity user;

  GetSingleUsersLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class GetSingleUsersFailure extends GetSingleUserState {
  @override
  List<Object> get props => [];
}
