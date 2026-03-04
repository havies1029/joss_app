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

	SppamvCrudState copyWith({
		SppamvCrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboRMatauangModel? comboRMatauang,
		ComboMMvmerkModel? comboMMvmerk,
		ComboMMvtipeModel? comboMMvtipe,
		ComboMMvjnscoverModel? comboMMvjnscover,
		ComboMWilayahModel? comboMWilayah,
		ComboMMvgrupOjkModel? comboMMvgrupOjk,
		ComboMWarnaModel? comboMWarna,
	}){
		return SppamvCrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboRMatauang: comboRMatauang?? this.comboRMatauang,
			comboMMvmerk: comboMMvmerk?? this.comboMMvmerk,
			comboMMvtipe: comboMMvtipe?? this.comboMMvtipe,
			comboMMvjnscover: comboMMvjnscover?? this.comboMMvjnscover,
			comboMWilayah: comboMWilayah?? this.comboMWilayah,
			comboMMvgrupOjk: comboMMvgrupOjk?? this.comboMMvgrupOjk,
			comboMWarna: comboMWarna?? this.comboMWarna,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
