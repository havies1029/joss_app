import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';

import '../../models/logoclient/mlogoclientcari_model.dart';
import '../../repositories/logoclient/mlogoclientcari_repository.dart';

part 'mlogoclientcari_event.dart';
part 'mlogoclientcari_state.dart';

class MlogoclientCariBloc
    extends Bloc<MlogoclientCariEvents, MlogoclientCariState> {
  MlogoclientCariBloc() : super(const MlogoclientCariState()) {
    on<FetchMlogoclientCariEvent>(onFetchMlogoclientCari);
    on<RefreshMlogoclientCariEvent>(onRefreshMlogoclientCari);
  }

  Future<void> onFetchMlogoclientCari(
      FetchMlogoclientCariEvent event,
      Emitter<MlogoclientCariState> emit,
      ) async {
    emit(state.copyWith(status: ListStatus.loadingMore));

    final repo = MlogoclientCariRepository();

    final items = await repo.getMlogoclientCari();

    emit(state.copyWith(
      status: ListStatus.success,
      items: items,
    ));
  }

  Future<void> onRefreshMlogoclientCari(
      RefreshMlogoclientCariEvent event,
      Emitter<MlogoclientCariState> emit,
      ) async {
    add(FetchMlogoclientCariEvent());
  }
}