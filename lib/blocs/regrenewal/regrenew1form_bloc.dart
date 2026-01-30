import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/regrenewal/regrenew1form_model.dart';
import 'package:joss_app/repositories/regrenewal/regrenew1form_repository.dart';

part 'regrenew1form_event.dart';
part 'regrenew1form_state.dart';

class Regrenew1FormBloc extends Bloc<Regrenew1FormEvents, Regrenew1FormState> {
	final Regrenew1FormRepository repository;
	Regrenew1FormBloc({required this.repository}) : super(const Regrenew1FormState()) {
		on<Regrenew1FormUbahEvent>(onUbahRegrenew1Form);
		on<Regrenew1FormTambahEvent>(onTambahRegrenew1Form);
		on<Regrenew1FormHapusEvent>(onHapusRegrenew1Form);
		on<Regrenew1FormLihatEvent>(onLihatRegrenew1Form);
	}

	Future<void> onTambahRegrenew1Form(
			Regrenew1FormTambahEvent event,
			Emitter<Regrenew1FormState> emit,
			) async {
		emit(state.copyWith(isSaving: true, isSaved: false, hasFailure: false));

		try {
			final returnData = await repository.regrenew1FormTambah(event.record);

			final hasFailure = !returnData.success;

			Regrenew1FormModel newRecord = event.record;

			if (returnData.success && returnData.data != null) {
				newRecord = event.record.copyWith(
					sppa1Id: returnData.data.toString(), // <-- simpan ID dari backend
				);
			}

			emit(state.copyWith(
				isSaving: false,
				isSaved: returnData.success,
				hasFailure: hasFailure,
				record: newRecord,
			));
		} catch (e) {
			emit(state.copyWith(
				isSaving: false,
				isSaved: false,
				hasFailure: true,
			));
		}
	}


	Future<void> onUbahRegrenew1Form(
		Regrenew1FormUbahEvent event, Emitter<Regrenew1FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regrenew1FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegrenew1Form(
		Regrenew1FormHapusEvent event, Emitter<Regrenew1FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regrenew1FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegrenew1Form(
		Regrenew1FormLihatEvent event, Emitter<Regrenew1FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regrenew1FormModel record = await repository.regrenew1FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}