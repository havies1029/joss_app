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
    emit(
      state.copyWith(
        isLoading: true,
        isLoaded: false,
        hasFailure: false,
        record: null,
        message: '',
      ),
    );

    try {
      final InvoiceStatusCards record =
      await repository.invToBayarViaCard(
        invoiceId: event.invoiceId,
        cardNumber: event.cardNumber,
        expiryMonth: event.expiryMonth,
        expiryYear: event.expiryYear,
        cvn: event.cvn,
        cardholderFirstName: event.cardholderFirstName,
        cardholderLastName: event.cardholderLastName,
      );

      final String redirectUrl = record.redirectUrl.trim();
      final Uri? redirectUri = Uri.tryParse(redirectUrl);

      final bool isValidRedirectUrl =
          redirectUri != null &&
              redirectUri.hasScheme &&
              (redirectUri.scheme == 'http' ||
                  redirectUri.scheme == 'https');

      if (!isValidRedirectUrl) {
        emit(
          state.copyWith(
            isLoading: false,
            isLoaded: false,
            hasFailure: true,
            record: null,
            message: _cleanMessage(
              redirectUrl.isNotEmpty
                  ? redirectUrl
                  : 'Pembayaran kartu gagal diproses.',
            ),
          ),
        );

        return;
      }

      emit(
        state.copyWith(
          isLoading: false,
          isLoaded: true,
          hasFailure: false,
          record: record,
          message: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isLoaded: false,
          hasFailure: true,
          record: null,
          message: _cleanMessage(e.toString()),
        ),
      );
    }
  }

  String _cleanMessage(String message) {
    String result = message.trim();

    result = result.replaceFirst('Exception: ', '');
    result = result.replaceAll(r'\"', '"');

    if (result.length >= 2 &&
        result.startsWith('"') &&
        result.endsWith('"')) {
      result = result.substring(1, result.length - 1);
    }

    return result.trim();
  }
}