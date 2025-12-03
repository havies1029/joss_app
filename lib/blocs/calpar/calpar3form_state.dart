part of 'calpar3form_bloc.dart';

class Calpar3FormState extends Equatable {

	final Calpar3FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
<<<<<<< HEAD
	final ComboMJnscoverParModel? comboMJnscoverPar;
	final ComboMWilayahModel? comboMWilayah;
	final ComboMKabZonaGempaModel? comboMKabZonaGempa;
	const Calpar3FormState(
			{this.record,
				this.isLoading = false,
				this.isLoaded = false,
				this.isSaving = false,
				this.isSaved = false,
				this.hasFailure = false,
				this.comboMJnscoverPar,
				this.comboMWilayah,
				this.comboMKabZonaGempa,
			});
=======
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
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398

	Calpar3FormState copyWith({
		Calpar3FormModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
<<<<<<< HEAD
		ComboMJnscoverParModel? comboMJnscoverPar,
=======
		ReturnDataAPI? returnData,
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
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
<<<<<<< HEAD
			comboMJnscoverPar: comboMJnscoverPar?? this.comboMJnscoverPar,
=======
			returnData: returnData ?? this.returnData,
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
			comboMWilayah: comboMWilayah?? this.comboMWilayah,
			comboMKabZonaGempa: comboMKabZonaGempa?? this.comboMKabZonaGempa,
		);
	}

	@override
<<<<<<< HEAD
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
=======
	List<Object?> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, returnData];
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
}
