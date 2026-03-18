import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';
import 'package:joss_app/models/gen_profile/mrekancontactcrud_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekancontactcrud_repository.dart';

part 'mrekancontactcrud_event.dart';
part 'mrekancontactcrud_state.dart';

class MRekanContactCrudBloc
		extends Bloc<MRekanContactCrudEvents, MRekanContactCrudState> {
	final MRekanContactCrudRepository repository;

	MRekanContactCrudBloc({required this.repository})
			: super(const MRekanContactCrudState()) {
		on<MRekanContactCrudUbahEvent>(onUbahMRekanContactCrud);
		on<MRekanContactCrudLihatEvent>(onLihatMRekanContactCrud);
		on<ComboMPropinsiChangedEvent>(onComboMPropinsiChanged);
		on<ComboMKotaChangedEvent>(onComboMKotaChanged);
		on<ComboRKodeposChangedEvent>(onComboRKodeposChanged);
		on<MRekanContactCrudResetStatusEvent>((event, emit) {
			emit(state.copyWith(
				isSaved: false,
				hasFailure: false,
			));
		});
	}

	Future<void> onUbahMRekanContactCrud(
			MRekanContactCrudUbahEvent event,
			Emitter<MRekanContactCrudState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final bool result = await repository.mRekanContactCrudUbah(event.record);
		final bool hasFailure = !result;

		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure,
			record: hasFailure ? state.record : event.record,
			comboMPropinsi:
			hasFailure ? state.comboMPropinsi : event.record.comboMPropinsi,
			comboMKota: hasFailure ? state.comboMKota : event.record.comboMKota,
			comboRKodepos:
			hasFailure ? state.comboRKodepos : event.record.comboRKodepos,
		));
	}

	Future<void> onLihatMRekanContactCrud(
			MRekanContactCrudLihatEvent event,
			Emitter<MRekanContactCrudState> emit,
			) async {
		emit(state.copyWith(
			isLoading: true,
			isLoaded: false,
			record: null,
		));

		try {
			final MRekanContactCrudModel record =
			await repository.mRekanContactCrudLihat();

			emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				record: record,
				comboMPropinsi: record.comboMPropinsi,
				comboMKota: record.comboMKota,
				comboRKodepos: record.comboRKodepos,
			));
		} catch (e) {
			emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				record: null,
				comboMPropinsi: null,
				comboMKota: null,
				comboRKodepos: null,
			));
		}
	}

	Future<void> onComboMPropinsiChanged(
			ComboMPropinsiChangedEvent event,
			Emitter<MRekanContactCrudState> emit,
			) async {
		emit(state.copyWith(
			comboMPropinsi: event.comboMPropinsi,
			comboMKota: null,
			comboRKodepos: null,
		));
	}

	Future<void> onComboMKotaChanged(
			ComboMKotaChangedEvent event,
			Emitter<MRekanContactCrudState> emit,
			) async {
		emit(state.copyWith(
			comboMKota: event.comboMKota,
			comboRKodepos: null,
		));
	}

	Future<void> onComboRKodeposChanged(
			ComboRKodeposChangedEvent event,
			Emitter<MRekanContactCrudState> emit,
			) async {
		emit(state.copyWith(
			comboRKodepos: event.comboRKodepos,
		));
	}
}