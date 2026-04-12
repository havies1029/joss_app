part of 'sppamvcrud_bloc.dart';

class SppamvCrudState extends Equatable {

	final SppamvCrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboRMatauangModel? comboRMatauang;
	final ComboMMvmerkModel? comboMMvmerk;
	final ComboMMvtipeModel? comboMMvtipe;
	final ComboMMvjnscoverModel? comboMMvjnscover;
	final ComboMWilayahModel? comboMWilayah;
	final ComboMMvgrupOjkModel? comboMMvgrupOjk;
	final ComboMWarnaModel? comboMWarna;
	const SppamvCrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboRMatauang,
		this.comboMMvmerk,
		this.comboMMvtipe,
		this.comboMMvjnscover,
		this.comboMWilayah,
		this.comboMMvgrupOjk,
		this.comboMWarna,
});

  static const _sentinel = Object();

	SppamvCrudState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboRMatauang = _sentinel,
		Object? comboMMvmerk = _sentinel,
		Object? comboMMvtipe = _sentinel,
		Object? comboMMvjnscover = _sentinel,
		Object? comboMWilayah = _sentinel,
		Object? comboMMvgrupOjk = _sentinel,
		Object? comboMWarna = _sentinel,
	}){
		return SppamvCrudState(
			record: identical(record, _sentinel) ? this.record : record as SppamvCrudModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboRMatauang: identical(comboRMatauang, _sentinel) ? this.comboRMatauang : comboRMatauang as ComboRMatauangModel?,
			comboMMvmerk: identical(comboMMvmerk, _sentinel) ? this.comboMMvmerk : comboMMvmerk as ComboMMvmerkModel?,
			comboMMvtipe: identical(comboMMvtipe, _sentinel) ? this.comboMMvtipe : comboMMvtipe as ComboMMvtipeModel?,
			comboMMvjnscover: identical(comboMMvjnscover, _sentinel) ? this.comboMMvjnscover : comboMMvjnscover as ComboMMvjnscoverModel?,
			comboMWilayah: identical(comboMWilayah, _sentinel) ? this.comboMWilayah : comboMWilayah as ComboMWilayahModel?,
			comboMMvgrupOjk: identical(comboMMvgrupOjk, _sentinel) ? this.comboMMvgrupOjk : comboMMvgrupOjk as ComboMMvgrupOjkModel?,
			comboMWarna: identical(comboMWarna, _sentinel) ? this.comboMWarna : comboMWarna as ComboMWarnaModel?,
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
		comboRMatauang,
		comboMMvmerk,
		comboMMvtipe,
		comboMMvjnscover,
		comboMWilayah,
		comboMMvgrupOjk,
		comboMWarna,
	];
}
