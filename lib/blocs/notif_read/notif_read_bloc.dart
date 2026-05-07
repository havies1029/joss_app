import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/repositories/notif_read/notif_read_repository.dart';

import '../../models/notif_read/notif_read_model.dart';

part 'notif_read_event.dart';
part 'notif_read_state.dart';

class NotifReadBloc extends Bloc<NotifReadEvents, NotifReadState> {
  NotifReadBloc() : super(const NotifReadState()) {
    on<MarkNotifReadEvent>(onMarkNotifRead);
    on<FetchNotifUnreadCountEvent>(onFetchNotifUnreadCount);
    on<RefreshNotifUnreadCountEvent>(onRefreshNotifUnreadCount);
  }

  Future<void> onMarkNotifRead(MarkNotifReadEvent event,
      Emitter<NotifReadState> emit,) async {
    emit(state.copyWith(
      status: ListStatus.loadingMore,
      isMarked: false,
    ));

    final repo = NotifReadRepository();

    final notif = NotifReadModel(
      notifType: event.notifType,
      notifId: event.notifId,
    );

    final result = await repo.markNotifRead(
      modulId: event.modulId,
      notifType: event.notifType,
      notifId: event.notifId,
    );

    emit(state.copyWith(
      status: ListStatus.success,
      item: notif,
      isMarked: result,
    ));
  }

  Future<void> onFetchNotifUnreadCount(FetchNotifUnreadCountEvent event,
      Emitter<NotifReadState> emit,) async {
    emit(state.copyWith(status: ListStatus.loadingMore));

    final repo = NotifReadRepository();

    final count = await repo.getNotifUnreadCount();

    emit(state.copyWith(
      status: ListStatus.success,
      unreadCount: count,
    ));
  }

  Future<void> onRefreshNotifUnreadCount(RefreshNotifUnreadCountEvent event,
      Emitter<NotifReadState> emit,) async {
    add(FetchNotifUnreadCountEvent());
  }
}