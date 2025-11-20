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

	Regmv3FormState copyWith({
		Regmv3FormModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboMWilayahModel? comboMWilayah,
		ComboMMvmerkModel? comboMMvmerk,
		ComboMMvtipeModel? comboMMvtipe,
		ComboMMvmodelModel? comboMMvmodel,
		ComboMWarnaModel? comboMWarna,
		ComboMMvpakaiModel? comboMMvpakai,
	}){
		return Regmv3FormState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMWilayah: comboMWilayah?? this.comboMWilayah,
			comboMMvmerk: comboMMvmerk?? this.comboMMvmerk,
			comboMMvtipe: comboMMvtipe?? this.comboMMvtipe,
			comboMMvmodel: comboMMvmodel?? this.comboMMvmodel,
			comboMWarna: comboMWarna?? this.comboMWarna,
			comboMMvpakai: comboMMvpakai?? this.comboMMvpakai,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
