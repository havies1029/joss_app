part of 'profile_bloc.dart';

abstract class UserEvents extends Equatable {
  const UserEvents();

  @override
  List<Object> get props => [];
}

class GetUserEvent extends UserEvents {}

class UpdateUserEvent extends UserEvents {
  final User user;
  const UpdateUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class DeleteUserEvent extends UserEvents {}
