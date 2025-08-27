import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combomtitle_model.dart';
import 'package:joss_app/models/combobox/combomtipecst_model.dart';
import 'package:joss_app/models/combobox/combombentukcst_model.dart';
import 'package:joss_app/models/combobox/combombidang_model.dart';
import 'package:joss_app/models/profile/mrekangeneral_model.dart';
import 'package:joss_app/repositories/profile/mrekangeneral_repository.dart';

part 'mrekangeneral_event.dart';
part 'mrekangeneral_state.dart';

class MRekanGeneralBloc extends Bloc<MRekanGeneralEvents, MRekanGeneralState> {
	final MRekanGeneralRepository repository;
	MRekanGeneralBloc({required this.repository}) : super(const MRekanGeneralState()) {
		on<MRekanGeneralUbahEvent>(onUbahMRekanGeneral);
		on<MRekanGeneralTambahEvent>(onTambahMRekanGeneral);
		on<MRekanGeneralHapusEvent>(onHapusMRekanGeneral);
		on<MRekanGeneralLihatEvent>(onLihatMRekanGeneral);
		on<ComboMTitleChangedEvent>(onComboMTitleChanged);
		on<ComboMTipeCstChangedEvent>(onComboMTipeCstChanged);
		on<ComboMBentukCstChangedEvent>(onComboMBentukCstChanged);
		on<ComboMBidangChangedEvent>(onComboMBidangChanged);
	}

	Future<void> onTambahMRekanGeneral(
		MRekanGeneralTambahEvent event, Emitter<MRekanGeneralState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.mRekanGeneralTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahMRekanGeneral(
		MRekanGeneralUbahEvent event, Emitter<MRekanGeneralState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.mRekanGeneralUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusMRekanGeneral(
		MRekanGeneralHapusEvent event, Emitter<MRekanGeneralState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.mRekanGeneralHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatMRekanGeneral(
		MRekanGeneralLihatEvent event, Emitter<MRekanGeneralState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		MRekanGeneralModel record = await repository.mRekanGeneralLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboMTitleChanged(
			ComboMTitleChangedEvent event, Emitter<MRekanGeneralState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMTitleModel comboMTitle = event.comboMTitle;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMTitle: comboMTitle));
	}

	Future<void> onComboMTipeCstChanged(
			ComboMTipeCstChangedEvent event, Emitter<MRekanGeneralState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMTipeCstModel comboMTipeCst = event.comboMTipeCst;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMTipeCst: comboMTipeCst));
	}

	Future<void> onComboMBentukCstChanged(
			ComboMBentukCstChangedEvent event, Emitter<MRekanGeneralState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMBentukCstModel comboMBentukCst = event.comboMBentukCst;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMBentukCst: comboMBentukCst));
	}

	Future<void> onComboMBidangChanged(
			ComboMBidangChangedEvent event, Emitter<MRekanGeneralState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMBidangModel comboMBidang = event.comboMBidang;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMBidang: comboMBidang));
	}

}