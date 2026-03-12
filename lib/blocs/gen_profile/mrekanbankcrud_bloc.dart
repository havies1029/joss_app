import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combombank_model.dart';
import 'package:joss_app/models/gen_profile/mrekanbankcrud_model.dart';
import 'package:joss_app/repositories/gen_profile/mrekanbankcrud_repository.dart';

part 'mrekanbankcrud_event.dart';
part 'mrekanbankcrud_state.dart';

class MRekanBankCrudBloc extends Bloc<MRekanBankCrudEvents, MRekanBankCrudState> {
	final MRekanBankCrudRepository repository;
	MRekanBankCrudBloc({required this.repository}) : super(const MRekanBankCrudState()) {
		on<MRekanBankCrudUbahEvent>(onUbahMRekanBankCrud);
		on<MRekanBankCrudTambahEvent>(onTambahMRekanBankCrud);
		on<MRekanBankCrudHapusEvent>(onHapusMRekanBankCrud);
		on<MRekanBankCrudLihatEvent>(onLihatMRekanBankCrud);
		on<ComboMBankChangedEvent>(onComboMBankChanged);
		on<MRekanBankCrudResetStatusEvent>((event, emit) {
			emit(state.copyWith(isSaved: false));
		});

	}

	Future<void> onTambahMRekanBankCrud(
			MRekanBankCrudTambahEvent event,
			Emitter<MRekanBankCrudState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
			record: null,
		));

		final ReturnDataAPI returnData =
		await repository.mRekanBankCrudTambah(event.record);

		final bool hasFailure = !returnData.success;

		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure,
			record: hasFailure ? null : event.record,
		));
	}

	Future<void> onUbahMRekanBankCrud(
			MRekanBankCrudUbahEvent event,
			Emitter<MRekanBankCrudState> emit,
			) async {
		emit(state.copyWith(
			isSaving: true,
			isSaved: false,
			hasFailure: false,
		));

		final bool result = await repository.mRekanBankCrudUbah(event.record);
		final bool hasFailure = !result;

		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure,
			record: hasFailure ? state.record : event.record,
		));
	}

	Future<void> onHapusMRekanBankCrud(
			MRekanBankCrudHapusEvent event, Emitter<MRekanBankCrudState> emit) async {

		emit(state.copyWith(isSaving: true, isSaved: false));

		bool result = await repository.mRekanBankCrudHapus(event.recordId);
		bool hasFailure = !result;

		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatMRekanBankCrud(
			MRekanBankCrudLihatEvent event,
			Emitter<MRekanBankCrudState> emit,
			) async {
		emit(state.copyWith(
			isLoading: true,
			isLoaded: false,
			record: null,
		));

		try {
			final record = await repository.mRekanBankCrudLihat();

			if (record.mrekanbankId.isEmpty) {
				emit(state.copyWith(
					isLoading: false,
					isLoaded: true,
					record: null,
					comboMBank: null,
				));
			} else {
				emit(state.copyWith(
					isLoading: false,
					isLoaded: true,
					record: record,
					comboMBank: record.comboMBank,
				));
			}
		} catch (e) {
			emit(state.copyWith(
				isLoading: false,
				isLoaded: true,
				record: null,
				comboMBank: null,
			));
		}
	}

	Future<void> onComboMBankChanged(
			ComboMBankChangedEvent event,
			Emitter<MRekanBankCrudState> emit,
			) async {
		emit(state.copyWith(
			comboMBank: event.comboMBank,
		));
	}
}