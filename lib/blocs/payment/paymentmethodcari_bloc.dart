import 'package:joss_app/repositories/payment/paymentdn_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'paymentmethodcari_event.dart';
import 'paymentmethodcari_state.dart';

class PaymentMethodCariBloc extends Bloc<PaymentMethodCariEvent, PaymentMethodCariState> {
  final PaymentDnRepository repository;

  PaymentMethodCariBloc({required this.repository})
      : super(const PaymentMethodCariState()) {
    on<PaymentMethodCariLoadEvent>(_onLoad);
    on<PaymentSelectMethodEvent>(_onSelectMethod);
  }

  Future<void> _onLoad(
      PaymentMethodCariLoadEvent event, Emitter<PaymentMethodCariState> emit) async {
    emit(state.copyWith(isLoading: true, hasError: false));

    try {
      final data = await repository.fetchPaymentMethods();

      emit(state.copyWith(
        isLoading: false,
        isLoaded: true,
        categories: data,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
      ));
    }
  }

  void _onSelectMethod(
      PaymentSelectMethodEvent event, Emitter<PaymentMethodCariState> emit) {
    emit(state.copyWith(selectedMethodId: event.methodId));
  }
}
