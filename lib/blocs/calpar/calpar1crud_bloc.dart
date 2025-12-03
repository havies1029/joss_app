import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
import 'package:joss_app/models/calpar/calpar1crud_model.dart';
import 'package:joss_app/repositories/calpar/calpar1crud_repository.dart';

part 'calpar1crud_event.dart';
part 'calpar1crud_state.dart';

<<<<<<< HEAD
class 	Calpar1CrudBloc extends Bloc<Calpar1CrudEvents, Calpar1CrudState> {
=======
class Calpar1CrudBloc extends Bloc<Calpar1CrudEvents, Calpar1CrudState> {
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
	final Calpar1CrudRepository repository;
	Calpar1CrudBloc({required this.repository}) : super(const Calpar1CrudState()) {
		on<Calpar1CrudUbahEvent>(onUbahCalpar1Crud);
		on<Calpar1CrudTambahEvent>(onTambahCalpar1Crud);
		on<Calpar1CrudHapusEvent>(onHapusCalpar1Crud);
		on<Calpar1CrudLihatEvent>(onLihatCalpar1Crud);
		on<ComboROkupasiChangedEvent>(onComboROkupasiChanged);
		on<ComboRKonstruksiojkChangedEvent>(onComboRKonstruksiojkChanged);
		on<ComboMJnscoverParChangedEvent>(onComboMJnscoverParChanged);
	}

	// Future<void> onTambahCalpar1Crud(
	// 	Calpar1CrudTambahEvent event, Emitter<Calpar1CrudState> emit) async {
	//
	// 	ReturnDataAPI returnData;
	// 	bool hasFailure = true;
	// 	emit(state.copyWith(isSaving: true, isSaved: false));
	// 	returnData = await repository.calpar1CrudTambah(event.record);
	// 	hasFailure = !returnData.success;
	// 	emit(state.copyWith(
	// 		isSaving: false,
	// 		isSaved: true,
	// 		hasFailure: hasFailure));
	// }

	Future<void> onTambahCalpar1Crud(
			Calpar1CrudTambahEvent event, Emitter<Calpar1CrudState> emit) async {

		debugPrint("🟢 [BLOC] onTambahCalpar1Crud triggered");
		emit(state.copyWith(isSaving: true, isSaved: false));

		final returnData = await repository.calpar1CrudTambah(event.record);

		debugPrint("📩 Response dari repository:");
		debugPrint("➡️ success=${returnData.success}");
		debugPrint("➡️ data=${returnData.data}");
		debugPrint("➡️ rowcount=${returnData.rowcount}");

		bool hasFailure = !returnData.success;

		Calpar1CrudModel newRecord = event.record;
		if (returnData.success && returnData.data is String) {
			newRecord = event.record.copyWith(calpar1Id: returnData.data.toString());
			debugPrint("✅ Set calmv1Id dari response string: ${newRecord.calpar1Id}");
		}

		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure,
			record: newRecord,
		));
	}

	Future<void> onUbahCalpar1Crud(
		Calpar1CrudUbahEvent event, Emitter<Calpar1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calpar1CrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusCalpar1Crud(
		Calpar1CrudHapusEvent event, Emitter<Calpar1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calpar1CrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatCalpar1Crud(
		Calpar1CrudLihatEvent event, Emitter<Calpar1CrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Calpar1CrudModel record = await repository.calpar1CrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onComboROkupasiChanged(
			ComboROkupasiChangedEvent event, Emitter<Calpar1CrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboROkupasiModel comboROkupasi = event.comboROkupasi;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboROkupasi: comboROkupasi));
	}

	Future<void> onComboRKonstruksiojkChanged(
			ComboRKonstruksiojkChangedEvent event, Emitter<Calpar1CrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRKonstruksiojkModel comboRKonstruksiojk = event.comboRKonstruksiojk;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRKonstruksiojk: comboRKonstruksiojk));
	}

	Future<void> onComboMJnscoverParChanged(
			ComboMJnscoverParChangedEvent event, Emitter<Calpar1CrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMJnscoverParModel comboMJnscoverPar = event.comboMJnscoverPar;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMJnscoverPar: comboMJnscoverPar));
	}

}