import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/regendors/regendors1form_model.dart';
import 'package:joss_app/repositories/regendors/regendors1form_repository.dart';

part 'regendors1form_event.dart';
part 'regendors1form_state.dart';

class Regendors1FormBloc extends Bloc<Regendors1FormEvents, Regendors1FormState> {
	final Regendors1FormRepository repository;
	Regendors1FormBloc({required this.repository}) : super(const Regendors1FormState()) {
		on<Regendors1FormUbahEvent>(onUbahRegendors1Form);
		on<Regendors1FormTambahEvent>(onTambahRegendors1Form);
		on<Regendors1FormHapusEvent>(onHapusRegendors1Form);
		on<Regendors1FormLihatEvent>(onLihatRegendors1Form);
	}

	Future<void> onTambahRegendors1Form(
			Regendors1FormTambahEvent event,
			Emitter<Regendors1FormState> emit,
			) async {
		emit(state.copyWith(isSaving: true, isSaved: false, hasFailure: false));

		try {
			final returnData = await repository.regendors1FormTambah(event.record);

			final hasFailure = !returnData.success;

			Regendors1FormModel newRecord = event.record;

			if (returnData.success) {
				newRecord = event.record.copyWith(
					sppa1Id: returnData.data.toString(),
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


	Future<void> onUbahRegendors1Form(
		Regendors1FormUbahEvent event, Emitter<Regendors1FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regendors1FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegendors1Form(
		Regendors1FormHapusEvent event, Emitter<Regendors1FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regendors1FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegendors1Form(
		Regendors1FormLihatEvent event, Emitter<Regendors1FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Regendors1FormModel record = await repository.regendors1FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}