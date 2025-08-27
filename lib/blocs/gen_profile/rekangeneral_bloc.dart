import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combomtitle_model.dart';
import 'package:joss_app/models/combobox/combomtipecst_model.dart';
import 'package:joss_app/models/combobox/combombentukcst_model.dart';
import 'package:joss_app/models/combobox/combombidang_model.dart';
import 'package:joss_app/models/combobox/combomjnskel_model.dart';
import 'package:joss_app/models/gen_profile/rekangeneral_model.dart';
import 'package:joss_app/repositories/gen_profile/rekangeneral_repository.dart';

part 'rekangeneral_event.dart';
part 'rekangeneral_state.dart';

class RekanGeneralBloc extends Bloc<RekanGeneralEvents, RekanGeneralState> {
	final RekanGeneralRepository repository;
	RekanGeneralBloc({required this.repository}) : super(const RekanGeneralState()) {
		on<RekanGeneralUbahEvent>(onUbahRekanGeneral);
		on<RekanGeneralTambahEvent>(onTambahRekanGeneral);
		on<RekanGeneralHapusEvent>(onHapusRekanGeneral);
		on<RekanGeneralLihatEvent>(onLihatRekanGeneral);
		on<ComboMTitleChangedEvent>(onComboMTitleChanged);
		on<ComboMTipeCstChangedEvent>(onComboMTipeCstChanged);
		on<ComboMBentukCstChangedEvent>(onComboMBentukCstChanged);
		on<ComboMBidangChangedEvent>(onComboMBidangChanged);
		on<ComboMJnskelChangedEvent>(onComboMJnskelChanged);
	}

	Future<void> onTambahRekanGeneral(
		RekanGeneralTambahEvent event, Emitter<RekanGeneralState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.rekanGeneralTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahRekanGeneral(
		RekanGeneralUbahEvent event, Emitter<RekanGeneralState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.rekanGeneralUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRekanGeneral(
		RekanGeneralHapusEvent event, Emitter<RekanGeneralState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.rekanGeneralHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRekanGeneral(
		RekanGeneralLihatEvent event, Emitter<RekanGeneralState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		RekanGeneralModel record = await repository.rekanGeneralLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboMTitleChanged(
			ComboMTitleChangedEvent event, Emitter<RekanGeneralState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMTitleModel comboMTitle = event.comboMTitle;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMTitle: comboMTitle));
	}

	Future<void> onComboMTipeCstChanged(
			ComboMTipeCstChangedEvent event, Emitter<RekanGeneralState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMTipeCstModel comboMTipeCst = event.comboMTipeCst;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMTipeCst: comboMTipeCst));
	}

	Future<void> onComboMBentukCstChanged(
			ComboMBentukCstChangedEvent event, Emitter<RekanGeneralState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMBentukCstModel comboMBentukCst = event.comboMBentukCst;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMBentukCst: comboMBentukCst));
	}

	Future<void> onComboMBidangChanged(
			ComboMBidangChangedEvent event, Emitter<RekanGeneralState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMBidangModel comboMBidang = event.comboMBidang;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMBidang: comboMBidang));
	}

	Future<void> onComboMJnskelChanged(
			ComboMJnskelChangedEvent event, Emitter<RekanGeneralState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMJnskelModel comboMJnskel = event.comboMJnskel;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMJnskel: comboMJnskel));
	}

}