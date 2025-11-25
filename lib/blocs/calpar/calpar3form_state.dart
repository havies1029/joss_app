part of 'calpar3form_bloc.dart';

class Calpar3FormState extends Equatable {

	final Calpar3FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ReturnDataAPI? returnData;

	final ComboMWilayahModel? comboMWilayah;
	final ComboMKabZonaGempaModel? comboMKabZonaGempa;
	const Calpar3FormState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
			this.returnData,

			this.comboMWilayah,
		this.comboMKabZonaGempa,
});

	Calpar3FormState copyWith({
		Calpar3FormModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ReturnDataAPI? returnData,
		ComboMWilayahModel? comboMWilayah,
		ComboMKabZonaGempaModel? comboMKabZonaGempa,
	}){
		return Calpar3FormState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			returnData: returnData ?? this.returnData,
			comboMWilayah: comboMWilayah?? this.comboMWilayah,
			comboMKabZonaGempa: comboMKabZonaGempa?? this.comboMKabZonaGempa,
		);
	}

	@override
	List<Object?> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, returnData];
}
