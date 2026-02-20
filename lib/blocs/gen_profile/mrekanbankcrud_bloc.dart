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
			MRekanBankCrudTambahEvent event, Emitter<MRekanBankCrudState> emit) async {
		print("🟡 [onTambahMRekanBankCrud] Memulai tambah data...");
		print("📤 Data yang dikirim: ${event.record.toJson()}");

		emit(state.copyWith(isSaving: true, isSaved: false));

		ReturnDataAPI returnData = await repository.mRekanBankCrudTambah(event.record);
		bool hasFailure = !returnData.success;

		// print("✅ [onTambahMRekanBankCrud] Response: ${returnData.toJson()}");

		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure,
		));
	}

	Future<void> onUbahMRekanBankCrud(
			MRekanBankCrudUbahEvent event, Emitter<MRekanBankCrudState> emit) async {

		emit(state.copyWith(isSaving: true, isSaved: false));

		bool result = await repository.mRekanBankCrudUbah(event.record);
		bool hasFailure = !result;
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
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

		emit(state.copyWith(isLoading: true, isLoaded: false));

		try {
			final record = await repository.mRekanBankCrudLihat(event.recordId);

			if (record.mrekanbankId.isEmpty) {
				emit(state.copyWith(isLoading: false, isLoaded: true, record: null));
			} else {
				emit(state.copyWith(
					isLoading: false,
					isLoaded: true,
					record: record,
					comboMBank: record.comboMBank,
				));
			}
		} catch (e) {
			emit(state.copyWith(isLoading: false, isLoaded: true, record: null));
		}
	}


	Future<void> onComboMBankChanged(
			ComboMBankChangedEvent event, Emitter<MRekanBankCrudState> emit) async {
		print("🔁 [onComboMBankChanged] Combo dipilih: ${event.comboMBank.toJson()}");

		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMBank: event.comboMBank,
		));
	}


}