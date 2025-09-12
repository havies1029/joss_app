import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/klaim/klaim2list_model.dart';
import 'package:joss_app/repositories/klaim/klaim2list_repository.dart';

part 'klaim2list_event.dart';
part 'klaim2list_state.dart';

class Klaim2ListBloc extends Bloc<Klaim2ListEvents, Klaim2ListState> {
  Klaim2ListBloc() : super(const Klaim2ListState()) {
    on<FetchKlaim2ListEvent>(onFetchKlaim2List);
    on<RefreshKlaim2ListEvent>(onRefreshKlaim2List);
    on<UbahKlaim2ListEvent>(onUbahKlaim2List);
    on<TambahKlaim2ListEvent>(onTambahKlaim2List);
    on<HapusKlaim2ListEvent>(onHapusKlaim2List);
    on<CloseDialogKlaim2ListEvent>(onCloseDialogKlaim2List);
  }

  Future<void> onRefreshKlaim2List(
      RefreshKlaim2ListEvent event, Emitter<Klaim2ListState> emit) async {
    emit(const Klaim2ListState());

    emit(state.copyWith(klaim1Id: event.klaim1Id));
    add(FetchKlaim2ListEvent());
  }

  Future<void> onFetchKlaim2List(
      FetchKlaim2ListEvent event, Emitter<Klaim2ListState> emit) async {
    if (state.hasReachedMax) return;

    debugPrint("onFetchKlaim2List");

    Klaim2ListRepository repo = Klaim2ListRepository();
    if (state.status == ListStatus.initial) {
      List<Klaim2ListModel> items = await repo.getKlaim2List(state.klaim1Id);
      return emit(state.copyWith(
          items: items,
          hasReachedMax: true,
          status: ListStatus.success,
          hal: 1));
    }
  }

  Future<void> onHapusKlaim2List(
      HapusKlaim2ListEvent event, Emitter<Klaim2ListState> emit) async {
    emit(state.copyWith(viewMode: ""));
    emit(state.copyWith(viewMode: "hapus"));
  }

  Future<void> onCloseDialogKlaim2List(
      CloseDialogKlaim2ListEvent event, Emitter<Klaim2ListState> emit) async {
    emit(state.copyWith(viewMode: ""));
  }

  Future<void> onTambahKlaim2List(
      TambahKlaim2ListEvent event, Emitter<Klaim2ListState> emit) async {
    emit(state.copyWith(viewMode: ""));
    emit(state.copyWith(viewMode: "tambah"));
  }

  Future<void> onUbahKlaim2List(
      UbahKlaim2ListEvent event, Emitter<Klaim2ListState> emit) async {
    emit(state.copyWith(viewMode: ""));
    emit(state.copyWith(viewMode: "ubah", recordId: event.recordId));
  }
}
