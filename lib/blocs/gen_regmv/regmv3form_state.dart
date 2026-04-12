part of 'regmv3form_bloc.dart';

class Regmv3FormState extends Equatable {

	final Regmv3FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMWilayahModel? comboMWilayah;
	final ComboMMvmerkModel? comboMMvmerk;
	final ComboMMvtipeModel? comboMMvtipe;
	final ComboMMvmodelModel? comboMMvmodel;
	final ComboMWarnaModel? comboMWarna;
	final ComboMMvpakaiModel? comboMMvpakai;
	const Regmv3FormState(
			{this.record,
				this.isLoading = false,
				this.isLoaded = false,
				this.isSaving = false,
				this.isSaved = false,
				this.hasFailure = false,
				this.comboMWilayah,
				this.comboMMvmerk,
				this.comboMMvtipe,
				this.comboMMvmodel,
				this.comboMWarna,
				this.comboMMvpakai,
			});

  static const _sentinel = Object();

	Regmv3FormState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMWilayah = _sentinel,
		Object? comboMMvmerk = _sentinel,
		Object? comboMMvtipe = _sentinel,
		Object? comboMMvmodel = _sentinel,
		Object? comboMWarna = _sentinel,
		Object? comboMMvpakai = _sentinel,
	}){
		return Regmv3FormState(
			record: identical(record, _sentinel) ? this.record : record as Regmv3FormModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMWilayah: identical(comboMWilayah, _sentinel) ? this.comboMWilayah : comboMWilayah as ComboMWilayahModel?,
			comboMMvmerk: identical(comboMMvmerk, _sentinel) ? this.comboMMvmerk : comboMMvmerk as ComboMMvmerkModel?,
			comboMMvtipe: identical(comboMMvtipe, _sentinel) ? this.comboMMvtipe : comboMMvtipe as ComboMMvtipeModel?,
			comboMMvmodel: identical(comboMMvmodel, _sentinel) ? this.comboMMvmodel : comboMMvmodel as ComboMMvmodelModel?,
			comboMWarna: identical(comboMWarna, _sentinel) ? this.comboMWarna : comboMWarna as ComboMWarnaModel?,
			comboMMvpakai: identical(comboMMvpakai, _sentinel) ? this.comboMMvpakai : comboMMvpakai as ComboMMvpakaiModel?,
		);
	}

	@override
	List<Object?> get props => [
		isLoading,
		isLoaded,
		isSaving,
		isSaved,
		hasFailure,
		record,
		comboMWilayah,
		comboMMvmerk,
		comboMMvtipe,
		comboMMvmodel,
		comboMWarna,
		comboMMvpakai,
	];
}
