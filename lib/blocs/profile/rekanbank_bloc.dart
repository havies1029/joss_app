import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combombank_model.dart';
import 'package:joss_app/models/profile/rekanbank_model.dart';
import 'package:joss_app/repositories/profile/rekanbank_repository.dart';

part 'rekanbank_event.dart';
part 'rekanbank_state.dart';

class RekanBankBloc extends Bloc<RekanBankEvents, RekanBankState> {
	final RekanBankRepository repository;
	RekanBankBloc({required this.repository}) : super(const RekanBankState()) {
		on<RekanBankUbahEvent>(onUbahRekanBank);
		on<RekanBankTambahEvent>(onTambahRekanBank);
		on<RekanBankHapusEvent>(onHapusRekanBank);
		on<RekanBankLihatEvent>(onLihatRekanBank);
		on<ComboMBankChangedEvent>(onComboMBankChanged);
	}

	Future<void> onTambahRekanBank(
		RekanBankTambahEvent event, Emitter<RekanBankState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.rekanBankTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahRekanBank(
		RekanBankUbahEvent event, Emitter<RekanBankState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.rekanBankUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRekanBank(
		RekanBankHapusEvent event, Emitter<RekanBankState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.rekanBankHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRekanBank(
		RekanBankLihatEvent event, Emitter<RekanBankState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		RekanBankModel record = await repository.rekanBankLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboMBankChanged(
			ComboMBankChangedEvent event, Emitter<RekanBankState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMBankModel comboMBank = event.comboMBank;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMBank: comboMBank));
	}

}