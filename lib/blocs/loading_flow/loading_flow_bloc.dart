import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';

import 'package:joss_app/blocs/gen_cob_app/cobmanpol_bloc.dart';
import 'package:joss_app/blocs/gen_status_aset/statusasetcari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_ringkasan/asetringkasancari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_par/asetparcari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_mv/asetmvcari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_hull/asethullcari_bloc.dart';
import 'package:joss_app/blocs/gen_aset_health/asethealthcari_bloc.dart';
import 'package:joss_app/blocs/asetothers/asetotherscari_bloc.dart';

part 'loading_flow_event.dart';
part 'loading_flow_state.dart';

class LoadingFlowBloc extends Bloc<LoadingFlowEvent, LoadingFlowState> {
  final CobManPolBloc cobManPolBloc;
  final StatusAsetCariBloc statusAsetCariBloc;

  final AsetRingkasanCariBloc asetRingkasanCariBloc;
  final AsetParCariBloc asetParCariBloc;
  final AsetMvCariBloc asetMvCariBloc;
  final AsethullCariBloc asethullCariBloc;
  final AsetHealthCariBloc asetHealthCariBloc;
  final AsetothersCariBloc asetothersCariBloc;

  StreamSubscription? _subTarget;
  Timer? _timeoutTimer;

  // rising-edge memory
  bool _lastTargetDone = false;

  LoadingFlowBloc({
    required this.cobManPolBloc,
    required this.statusAsetCariBloc,
    required this.asetRingkasanCariBloc,
    required this.asetParCariBloc,
    required this.asetMvCariBloc,
    required this.asethullCariBloc,
    required this.asetHealthCariBloc,
    required this.asetothersCariBloc,
  }) : super(const LoadingFlowState()) {
    on<LoadingFlowStartEvent>(_onStart);
    on<LoadingFlowResetEvent>(_onReset);
    on<_LoadingFlowCompletedEvent>(_onCompleted);
    on<_LoadingFlowTimeoutEvent>(_onTimeout);
  }

  Future<void> _cleanup() async {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;

    await _subTarget?.cancel();
    _subTarget = null;

    _lastTargetDone = false;
  }

  @override
  Future<void> close() async {
    await _cleanup();
    return super.close();
  }

  Future<void> _onReset(LoadingFlowResetEvent event, Emitter<LoadingFlowState> emit) async {
    await _cleanup();
    emit(const LoadingFlowState());
  }

  Future<void> _onStart(LoadingFlowStartEvent event, Emitter<LoadingFlowState> emit) async {
    await _cleanup();

    emit(const LoadingFlowState().copyWith(
      status: LoadingFlowStatus.loading,
      result: null,
      message: null,
      stepTriggered: true,
      cobId: event.cobId,
      statusId: event.statusId,
      searchText: event.searchText,
    ));

    // timeout biar overlay gak nyangkut
    _timeoutTimer = Timer(Duration(milliseconds: event.timeoutMs), () {
      add(const _LoadingFlowTimeoutEvent());
    });

    // Dispatch sesuai mapping refreshData() kamu
    final target = _dispatchTargetByCob(
      cobId: event.cobId,
      statusId: event.statusId,
      searchText: event.searchText,
    );

    // Listen target sampai DONE (success/failure) dengan rising-edge
    _subTarget = target?.stream.listen((s) {
      final st = (s as dynamic).status as ListStatus;

      final doneNow = (st == ListStatus.success || st == ListStatus.failure);
      final rising = !_lastTargetDone && doneNow;
      _lastTargetDone = doneNow;

      if (!rising) return;

      final ok = st == ListStatus.success;
      add(_LoadingFlowCompletedEvent(ok: ok, message: ok ? null : "Fetch gagal"));
    });
  }

  void _onCompleted(_LoadingFlowCompletedEvent event, Emitter<LoadingFlowState> emit) {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;

    emit(state.copyWith(
      status: event.ok ? LoadingFlowStatus.success : LoadingFlowStatus.failure,
      result: event.ok,
      message: event.message,
    ));
  }

  void _onTimeout(_LoadingFlowTimeoutEvent event, Emitter<LoadingFlowState> emit) {
    if (state.status != LoadingFlowStatus.loading) return;
    emit(state.copyWith(
      status: LoadingFlowStatus.failure,
      result: false,
      message: "Timeout: request belum selesai",
    ));
  }

  BlocBase<dynamic>? _dispatchTargetByCob({
    required String cobId,
    required String statusId,
    required String searchText,
  }) {
    final cleanCobId = cobId.trim();
    final cleanStatusId = statusId.trim();

    // guard: kalau input invalid, gak dispatch apa-apa
    if (cleanCobId.isEmpty || cleanStatusId.isEmpty) return null;

    switch (cleanCobId) {
      case "10001":
        asetRingkasanCariBloc.add(
          RefreshAsetRingkasanCariEvent(
            statusId: cleanStatusId,
            searchText: searchText,
          ),
        );
        return asetRingkasanCariBloc;

      case "10002":
        asetParCariBloc.add(
          RefreshAsetParCariEvent(statusId: cleanStatusId, searchText: searchText),
        );
        return asetParCariBloc;

      case "10003":
        asetMvCariBloc.add(
          RefreshAsetMvCariEvent(statusId: cleanStatusId, searchText: searchText),
        );
        return asetMvCariBloc;

      case "10004":
        asethullCariBloc.add(
          RefreshAsethullCariEvent(statusId: cleanStatusId, searchText: searchText),
        );
        return asethullCariBloc;

      case "10005":
        asetHealthCariBloc.add(
          RefreshAsetHealthCariEvent(statusId: cleanStatusId, searchText: searchText),
        );
        return asetHealthCariBloc;

      default:
        asetothersCariBloc.add(
          RefreshAsetothersCariEvent(
            statusId: cleanStatusId,
            searchText: searchText,
            cobId: cleanCobId,
          ),
        );
        return asetothersCariBloc;
    }
  }

}
