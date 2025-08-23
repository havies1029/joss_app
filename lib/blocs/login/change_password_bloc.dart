import 'package:equatable/equatable.dart';
import 'package:joss_app/models/authentication/change_password_model.dart';
import 'package:joss_app/repositories/login/change_password_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordRepository repository;

  ChangePasswordBloc({required this.repository})
      : super(const ChangePasswordState()) {
    on<UserChangePasswordEvent>(onUserChangePassword);
  }

  Future<void> onUserChangePassword(
      UserChangePasswordEvent event, Emitter<ChangePasswordState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false, hasFailure: false));

    bool hasFailure = !await repository.changePassword(event.pswd);

    emit(
        state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }
}
