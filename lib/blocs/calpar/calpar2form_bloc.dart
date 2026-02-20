import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/combombiindemnityojk_model.dart';
import 'package:joss_app/models/calpar/calpar2form_model.dart';
import 'package:joss_app/repositories/calpar/calpar2form_repository.dart';

part 'calpar2form_event.dart';
part 'calpar2form_state.dart';

class Calpar2FormBloc extends Bloc<Calpar2FormEvents, Calpar2FormState> {
	final Calpar2FormRepository repository;
	Calpar2FormBloc({required this.repository}) : super(const Calpar2FormState()) {
		on<Calpar2FormUbahEvent>(onUbahCalpar2Form);
		on<Calpar2FormTambahEvent>(onTambahCalpar2Form);
		on<Calpar2FormHapusEvent>(onHapusCalpar2Form);
		on<Calpar2FormLihatEvent>(onLihatCalpar2Form);
		on<ComboRMatauangChangedEvent>(onComboRMatauangChanged);
		on<ComboMBiindemnityOjkChangedEvent>(onComboMBiindemnityOjkChanged);
		on<Calpar2DraftEvent>(onDraftCalpar2Crud);
	}

	Future<void> onDraftCalpar2Crud(
			Calpar2DraftEvent event,
			Emitter<Calpar2FormState> emit,
			) async {
		emit(state.copyWith(
			record: event.record,
			// opsional kalau mau reset flag:
			// isSaved: false,
			// hasFailure: false,
		));
	}

	Future<void> onTambahCalpar2Form(
			Calpar2FormTambahEvent event,
			Emitter<Calpar2FormState> emit,
			) async {
		emit(state.copyWith(isSaving: true, isSaved: false));

		final ReturnDataAPI returnData = await repository.calpar2FormTambah(event.record);

		final hasFailure = !returnData.success;

		final newId = returnData.data.toString() ?? "";

		final savedRecord = Calpar2FormModel(
			calpar2Id: newId,
			calpar1Id: event.record.calpar1Id,

			biIndexRate: event.record.biIndexRate,
			biTotal: event.record.biTotal,
			siBi: event.record.siBi,
			siBuilding: event.record.siBuilding,
			siContent: event.record.siContent,
			siMachinery: event.record.siMachinery,
			siOther: event.record.siOther,
			siStock: event.record.siStock,
			stockAdjustable: event.record.stockAdjustable,

			comboMBiindemnityOjk: event.record.comboMBiindemnityOjk,
			comboRMatauang: event.record.comboRMatauang,
		);

		// ✔ Emit ke UI
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure,
			record: savedRecord,
			returnData: returnData,
		));
	}
	Future<void> onUbahCalpar2Form(
			Calpar2FormUbahEvent event,
			Emitter<Calpar2FormState> emit,
			) async {
		emit(state.copyWith(isSaving: true, isSaved: false));

		final ReturnDataAPI returnData =
		await repository.calpar2FormUbah(event.record);

		final hasFailure = !returnData.success;
		final incomingId = returnData.data.trim();
		final fixedId =
		incomingId.isNotEmpty ? incomingId : event.record.calpar2Id;

		final savedRecord = Calpar2FormModel(
			calpar2Id: fixedId,
			calpar1Id: event.record.calpar1Id,

			biIndexRate: event.record.biIndexRate,
			biTotal: event.record.biTotal,
			siBi: event.record.siBi,
			siBuilding: event.record.siBuilding,
			siContent: event.record.siContent,
			siMachinery: event.record.siMachinery,
			siOther: event.record.siOther,
			siStock: event.record.siStock,
			stockAdjustable: event.record.stockAdjustable,

			comboMBiindemnityOjk: event.record.comboMBiindemnityOjk,
			comboRMatauang: event.record.comboRMatauang,
		);

		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure,
			record: savedRecord,
			returnData: returnData,
		));
	}



	Future<void> onHapusCalpar2Form(
		Calpar2FormHapusEvent event, Emitter<Calpar2FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calpar2FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatCalpar2Form(
		Calpar2FormLihatEvent event, Emitter<Calpar2FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Calpar2FormModel record = await repository.calpar2FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboRMatauangChanged(
			ComboRMatauangChangedEvent event, Emitter<Calpar2FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRMatauangModel comboRMatauang = event.comboRMatauang;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRMatauang: comboRMatauang));
	}

	Future<void> onComboMBiindemnityOjkChanged(
			ComboMBiindemnityOjkChangedEvent event, Emitter<Calpar2FormState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMBiindemnityOjkModel comboMBiindemnityOjk = event.comboMBiindemnityOjk;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMBiindemnityOjk: comboMBiindemnityOjk));
	}

}