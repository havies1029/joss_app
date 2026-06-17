import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/payment/invoicestatuscard_model.dart';
import 'package:joss_app/repositories/payment/invoicestatuscard_repository.dart';

part 'invoicestatuscard_event.dart';
part 'invoicestatuscard_state.dart';

class InvoiceStatusCardBloc
    extends Bloc<InvoiceStatusCardEvents, InvoiceStatusCardState> {
  final InvoiceStatusCardRepository repository;

  InvoiceStatusCardBloc({required this.repository})
      : super(const InvoiceStatusCardState()) {
    on<InvToBayarViaCardEvent>(onInvToBayarViaCard);
  }

  Future<void> onInvToBayarViaCard(
      InvToBayarViaCardEvent event,
      Emitter<InvoiceStatusCardState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      isLoaded: false,
      hasFailure: false,
    ));

    try {
      InvoiceStatusCards record = await repository.invToBayarViaCard(
        invoiceId: event.invoiceId,
        cardNumber: event.cardNumber,
        expiryMonth: event.expiryMonth,
        expiryYear: event.expiryYear,
        cvn: event.cvn,
        cardholderFirstName: event.cardholderFirstName,
        cardholderLastName: event.cardholderLastName,
      );

      emit(state.copyWith(
        isLoading: false,
        isLoaded: true,
        hasFailure: false,
        record: record,
      ));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        isLoaded: false,
        hasFailure: true,
      ));
    }
  }
}