import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/payment/dnrekap2inv_bloc.dart';
import 'package:joss_app/models/payment/invbayarvaform_model.dart';
import 'package:joss_app/models/payment/invoicestatus_model.dart';
import 'package:joss_app/repositories/payment/invbayarvaform_repository.dart';
import 'package:joss_app/repositories/payment/paymentdn_repository.dart';

part 'invbayarvaform_event.dart';
part 'invbayarvaform_state.dart';

class InvbayarvaFormBloc
    extends Bloc<InvbayarvaFormEvents, InvbayarvaFormState> {
  final InvbayarvaFormRepository infoVArepository;
  final PaymentDnRepository paymentDnRepository;
  final DnRekap2invBloc dnRekap2invBloc;

  Timer? _vaTimer;
  Timer? _statusTimer;
  int _vaAttempt = 0;
  int _statusAttempt = 0;

  InvbayarvaFormBloc({required this.infoVArepository, required this.paymentDnRepository, required this.dnRekap2invBloc})
      : super(const InvbayarvaFormState()) {
    on<InvbayarvaPollingStarted>(_onStartPolling);
    on<InvbayarvaPollingStopped>(_onStopPolling);

    on<_VaPollingTick>(_onVaTick);
    on<_StatusPollingTick>(_onStatusTick);
  }
  void _onStartPolling(
      InvbayarvaPollingStarted event,
      Emitter<InvbayarvaFormState> emit,
      ) {
    _stopAllTimers();

    _vaAttempt = 0;
    _statusAttempt = 0;

    emit(state.copyWith(
      isPollingVa: true,
      isPollingStatus: false,
      isInitialLoading: true,
    ));

    _vaTimer = Timer.periodic(event.interval, (_) {
      _vaAttempt++;
      add(_VaPollingTick(invoiceId: event.invoiceId));
    });

    add(_VaPollingTick(invoiceId: event.invoiceId));
  }

  Future<void> _onVaTick(
      _VaPollingTick event,
      Emitter<InvbayarvaFormState> emit,
      ) async {
    if (!state.isPollingVa) return;

    try {
      final record =
      await infoVArepository.invbayarvaFormLihat(event.invoiceId);

      emit(state.copyWith(
        record: record,
        isInitialLoading: false,
      ));

      final va = (record.vaNo).trim();

      if (va.isNotEmpty) {
        _vaTimer?.cancel();
        _vaTimer = null;

        _statusTimer?.cancel();
        _statusTimer = null;

        emit(state.copyWith(
          isPollingVa: false,
          isPollingStatus: true,
        ));

        _startStatusPolling(event.invoiceId);
      }
    } catch (_) {
      emit(state.copyWith(
        isInitialLoading: false,
      ));
    }
  }

  Future<void> _onStatusTick(_StatusPollingTick event,Emitter<InvbayarvaFormState> emit,) async {
    if (!state.isPollingStatus) return;

    try {
      final InvoiceStatusModel recordStatus =
          await paymentDnRepository.fetchInvoiceStatus(event.invoiceId);

      final currentRecord =
          state.record ?? InvbayarvaFormModel.empty();

      final updatedRecord =
          currentRecord.copyWith(paymentStatus: recordStatus.status);

      emit(state.copyWith(record: updatedRecord));

      final status = recordStatus.status;

      if (status == "40" || status == "50") {
        _statusTimer?.cancel();
        _statusTimer = null;

        emit(state.copyWith(isPollingStatus: false));

        dnRekap2invBloc.add(SetRecordInvoiceStatusEvent(invoiceStatusRecord: recordStatus));

      }
    } catch (_) {}

  }

  void _onStopPolling(
      InvbayarvaPollingStopped event,
      Emitter<InvbayarvaFormState> emit,
      ) {
    _stopAllTimers();

    emit(state.copyWith(
      isPollingVa: false,
      isPollingStatus: false,
      isInitialLoading: false,
    ));
  }

  void _stopAllTimers() {
    _vaTimer?.cancel();
    _statusTimer?.cancel();
    _vaTimer = null;
    _statusTimer = null;
  }

  @override
  Future<void> close() {
    _stopAllTimers();
    return super.close();
  }

  void _startStatusPolling(String invoiceId) {
    if (!state.isPollingStatus) return;

    _statusTimer = Timer(const Duration(seconds: 10), () async {
      add(_StatusPollingTick(invoiceId: invoiceId));

      // schedule lagi hanya jika masih polling
      if (state.isPollingStatus) {
        _startStatusPolling(invoiceId);
      }
    });
  }

}