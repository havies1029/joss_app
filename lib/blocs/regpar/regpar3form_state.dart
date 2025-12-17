part of 'regpar3form_bloc.dart';

class Regpar3FormState extends Equatable {

	final Regpar3FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMJnscoverParModel? comboMJnscoverPar;
	final ComboMWilayahModel? comboMWilayah;
	final ComboMKabZonaGempaModel? comboMKabZonaGempa;
	const Regpar3FormState(
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

	Regpar3FormState copyWith({
		Regpar3FormModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboMJnscoverParModel? comboMJnscoverPar,
		ComboMWilayahModel? comboMWilayah,
		ComboMKabZonaGempaModel? comboMKabZonaGempa,
	}){
		return Regpar3FormState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMJnscoverPar: comboMJnscoverPar?? this.comboMJnscoverPar,
			comboMWilayah: comboMWilayah?? this.comboMWilayah,
			comboMKabZonaGempa: comboMKabZonaGempa?? this.comboMKabZonaGempa,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}