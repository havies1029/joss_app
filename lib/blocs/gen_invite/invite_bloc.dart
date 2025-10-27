// lib/blocs/gen_invite/invite_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/gen_invite/invite_model.dart';
import 'package:joss_app/repositories/gen_invite/invite_repository.dart';

part 'invite_event.dart';
part 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  final InviteRepository repo;

  InviteBloc({required this.repo}) : super(const InviteState()) {
    on<SendInviteEvent>(_onSendInvite);
  }

  Future<void> _onSendInvite(SendInviteEvent event, Emitter<InviteState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, message: ''));

    try {
      final result = await repo.sendInvite(event.userId, event.email);
      emit(state.copyWith(
        isLoading: false,
        isSuccess: result.success,
        message: result.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: e.toString(),
      ));
    }
  }
}
