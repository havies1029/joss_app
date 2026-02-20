import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/combobox/comborokupasi_model.dart';
import 'package:joss_app/models/combobox/comborkonstruksiojk_model.dart';
import 'package:joss_app/models/combobox/combomjnscoverpar_model.dart';
import 'package:joss_app/models/calpar/calpar1crud_model.dart';
import 'package:joss_app/repositories/calpar/calpar1crud_repository.dart';

part 'calpar1crud_event.dart';
part 'calpar1crud_state.dart';

class 	Calpar1CrudBloc extends Bloc<Calpar1CrudEvents, Calpar1CrudState> {
	final Calpar1CrudRepository repository;
	Calpar1CrudBloc({required this.repository}) : super(const Calpar1CrudState()) {
		on<Calpar1CrudUbahEvent>(onUbahCalpar1Crud);
		on<Calpar1CrudTambahEvent>(onTambahCalpar1Crud);
		on<Calpar1CrudHapusEvent>(onHapusCalpar1Crud);
		on<Calpar1CrudLihatEvent>(onLihatCalpar1Crud);
		on<ComboROkupasiChangedEvent>(onComboROkupasiChanged);
		on<ComboRKonstruksiojkChangedEvent>(onComboRKonstruksiojkChanged);
		on<ComboMJnscoverParChangedEvent>(onComboMJnscoverParChanged);
		on<Calpar1DraftEvent>(onDraftCalpar1Crud);
	}

	Future<void> onDraftCalpar1Crud(
			Calpar1DraftEvent event,
			Emitter<Calpar1CrudState> emit,
			) async {
		emit(state.copyWith(
			record: event.record,
			// opsional kalau mau reset flag:
			// isSaved: false,
			// hasFailure: false,
		));
	}

	Future<void> onTambahCalpar1Crud(
			Calpar1CrudTambahEvent event, Emitter<Calpar1CrudState> emit) async {

		emit(state.copyWith(isSaving: true, isSaved: false));
		final returnData = await repository.calpar1CrudTambah(event.record);
		bool hasFailure = !returnData.success;
		Calpar1CrudModel newRecord = event.record;
		if (returnData.success) {
			newRecord = event.record.copyWith(calpar1Id: returnData.data.toString());
		}

		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure,
			record: newRecord,
		));
	}

	Future<void> onUbahCalpar1Crud(
			Calpar1CrudUbahEvent event,
			Emitter<Calpar1CrudState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final ok = await repository.calpar1CrudUbah(event.record);
		final hasFailure = !ok;

		emit(state.copyWith(
			isSaving: false,
			isSaved: !hasFailure,
			hasFailure: hasFailure,
			record: event.record,
		));
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