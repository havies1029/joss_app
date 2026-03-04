import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/combobox/combommvmerk_model.dart';
import 'package:joss_app/models/combobox/combommvtipe_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/combobox/combomwarna_model.dart';
import 'package:joss_app/models/gen_sppamv/sppamvcrud_model.dart';
import 'package:joss_app/repositories/gen_sppamv/sppamvcrud_repository.dart';

part 'sppamvcrud_event.dart';
part 'sppamvcrud_state.dart';

class SppamvCrudBloc extends Bloc<SppamvCrudEvents, SppamvCrudState> {
	final SppamvCrudRepository repository;
	SppamvCrudBloc({required this.repository}) : super(const SppamvCrudState()) {
		on<SppamvCrudUbahEvent>(onUbahSppamvCrud);
		on<SppamvCrudTambahEvent>(onTambahSppamvCrud);
		on<SppamvCrudHapusEvent>(onHapusSppamvCrud);
		on<SppamvCrudLihatEvent>(onLihatSppamvCrud);
		on<ComboRMatauangChangedEvent>(onComboRMatauangChanged);
		on<ComboMMvmerkChangedEvent>(onComboMMvmerkChanged);
		on<ComboMMvtipeChangedEvent>(onComboMMvtipeChanged);
		on<ComboMMvjnscoverChangedEvent>(onComboMMvjnscoverChanged);
		on<ComboMWilayahChangedEvent>(onComboMWilayahChanged);
		on<ComboMMvgrupOjkChangedEvent>(onComboMMvgrupOjkChanged);
		on<ComboMWarnaChangedEvent>(onComboMWarnaChanged);
	}

	Future<void> onTambahSppamvCrud(
		SppamvCrudTambahEvent event, Emitter<SppamvCrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.sppamvCrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahSppamvCrud(
		SppamvCrudUbahEvent event, Emitter<SppamvCrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.sppamvCrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusSppamvCrud(
		SppamvCrudHapusEvent event, Emitter<SppamvCrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.sppamvCrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatSppamvCrud(
		SppamvCrudLihatEvent event, Emitter<SppamvCrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		SppamvCrudModel record = await repository.sppamvCrudLihat(event.recordId);

		emit(state.copyWith(isLoading: false, isLoaded: true, record: record,
      comboMMvmerk: record.comboMMvmerk,
      comboMMvtipe: record.comboMMvtipe,
      comboMMvjnscover: record.comboMMvjnscover,
      comboMWilayah: record.comboMWilayah,
      comboMMvgrupOjk: record.comboMMvgrupOjk,
      comboMWarna: record.comboMWarna));
	}

	Future<void> onComboRMatauangChanged(
			ComboRMatauangChangedEvent event, Emitter<SppamvCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboRMatauangModel comboRMatauang = event.comboRMatauang;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboRMatauang: comboRMatauang));
	}

	Future<void> onComboMMvmerkChanged(
			ComboMMvmerkChangedEvent event, Emitter<SppamvCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMMvmerkModel comboMMvmerk = event.comboMMvmerk;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMMvmerk: comboMMvmerk));
	}

	Future<void> onComboMMvtipeChanged(
			ComboMMvtipeChangedEvent event, Emitter<SppamvCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMMvtipeModel comboMMvtipe = event.comboMMvtipe;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMMvtipe: comboMMvtipe));
	}

	Future<void> onComboMMvjnscoverChanged(
			ComboMMvjnscoverChangedEvent event, Emitter<SppamvCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMMvjnscoverModel comboMMvjnscover = event.comboMMvjnscover;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMMvjnscover: comboMMvjnscover));
	}

	Future<void> onComboMWilayahChanged(
			ComboMWilayahChangedEvent event, Emitter<SppamvCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMWilayahModel comboMWilayah = event.comboMWilayah;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMWilayah: comboMWilayah));
	}

	Future<void> onComboMMvgrupOjkChanged(
			ComboMMvgrupOjkChangedEvent event, Emitter<SppamvCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMMvgrupOjkModel comboMMvgrupOjk = event.comboMMvgrupOjk;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMMvgrupOjk: comboMMvgrupOjk));
	}

	Future<void> onComboMWarnaChanged(
			ComboMWarnaChangedEvent event, Emitter<SppamvCrudState> emit) async {

		emit(state.copyWith(isLoading: true, isLoaded: false));

		ComboMWarnaModel comboMWarna = event.comboMWarna;
		emit(state.copyWith(
			isLoading: false,
			isLoaded: true,
			comboMWarna: comboMWarna));
	}

}