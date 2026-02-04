import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/payment/invbayarvaform_model.dart';
import 'package:joss_app/repositories/payment/invbayarvaform_repository.dart';

part 'invbayarvaform_event.dart';
part 'invbayarvaform_state.dart';

class InvbayarvaFormBloc extends Bloc<InvbayarvaFormEvents, InvbayarvaFormState> {
	final InvbayarvaFormRepository repository;
	InvbayarvaFormBloc({required this.repository}) : super(const InvbayarvaFormState()) {
		on<InvbayarvaFormLihatEvent>(onLihatInvbayarvaForm);
	}

	Future<void> onLihatInvbayarvaForm(
		InvbayarvaFormLihatEvent event, Emitter<InvbayarvaFormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		InvbayarvaFormModel record = await repository.invbayarvaFormLihat(event.invoiceId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}
}