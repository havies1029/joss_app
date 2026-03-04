import 'package:joss_app/common/app_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/user/user_model.dart';
import 'package:joss_app/repositories/user/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<UserEvents, UserState> {
  final UserRepository userRepository;
  final int id;

  ProfileBloc({required this.userRepository, required this.id})
      : super(UserState(isLoading: true)) {
    on<GetUserEvent>(_onGetUser);
    on<UpdateUserEvent>(_onUpdateUser);
  }

  Future<void> _onGetUser(GetUserEvent event, Emitter<UserState> emit) async {
    emit(UserState(isLoading: true, isLoaded: false));
    User user = AppData.user;   
    emit(UserState(user: user, isLoading: false, isLoaded: true));
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UserState(
      isSaving: true,
      isSaved: false,
    ));

    event.user.id = 0;
    //event.user.username = "";

    bool isSuccessful = await userRepository.updateUser(event.user);

    //debugPrint("profile_block -> _onUpdateUser #20");

    emit(UserState(
      isSaving: false,
      isSaved: isSuccessful,
      hasFailure: !isSuccessful,
    ));

    //debugPrint("profile_block -> _onUpdateUser #30");
  }
  
}
