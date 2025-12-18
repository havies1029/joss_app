import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combombank_model.dart';
import 'package:joss_app/models/payment/invbayarvaform_model.dart';
import 'package:joss_app/repositories/payment/invbayarvaform_repository.dart';

part 'invbayarvaform_event.dart';
part 'invbayarvaform_state.dart';

class InvbayarvaFormBloc extends Bloc<InvbayarvaFormEvents, InvbayarvaFormState> {
	final InvbayarvaFormRepository repository;
	InvbayarvaFormBloc({required this.repository}) : super(const InvbayarvaFormState()) {
		on<InvbayarvaFormUbahEvent>(onUbahInvbayarvaForm);
		on<InvbayarvaFormTambahEvent>(onTambahInvbayarvaForm);
		on<InvbayarvaFormHapusEvent>(onHapusInvbayarvaForm);
		on<InvbayarvaFormLihatEvent>(onLihatInvbayarvaForm);
		on<ComboMBankChangedEvent>(onComboMBankChanged);
	}

	Future<void> onTambahInvbayarvaForm(
		InvbayarvaFormTambahEvent event, Emitter<InvbayarvaFormState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.invbayarvaFormTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahInvbayarvaForm(
		InvbayarvaFormUbahEvent event, Emitter<InvbayarvaFormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.invbayarvaFormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusInvbayarvaForm(
		InvbayarvaFormHapusEvent event, Emitter<InvbayarvaFormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.invbayarvaFormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatInvbayarvaForm(
		InvbayarvaFormLihatEvent event, Emitter<InvbayarvaFormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		InvbayarvaFormModel record = await repository.invbayarvaFormLihat(event.invoiceId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboMBankChanged(
			ComboMBankChangedEvent event, Emitter<InvbayarvaFormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMBankModel comboMBank = event.comboMBank;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMBank: comboMBank));
	}

}