part of 'calpar3form_bloc.dart';

class Calpar3FormState extends Equatable {
	final Calpar3FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;

	final ReturnDataAPI? returnData;

	final ComboMJnscoverParModel? comboMJnscoverPar;
	final ComboMWilayahModel? comboMWilayah;
	final ComboMKabZonaGempaModel? comboMKabZonaGempa;

	const Calpar3FormState({
		this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.returnData,
		this.comboMJnscoverPar,
		this.comboMWilayah,
		this.comboMKabZonaGempa,
	});

  static const _sentinel = Object();

	Calpar3FormState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? returnData = _sentinel,
		Object? comboMJnscoverPar = _sentinel,
		Object? comboMWilayah = _sentinel,
		Object? comboMKabZonaGempa = _sentinel,
	}) {
		return Calpar3FormState(
			record: identical(record, _sentinel) ? this.record : record as Calpar3FormModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			returnData: identical(returnData, _sentinel) ? this.returnData : returnData as ReturnDataAPI?,
			comboMJnscoverPar: identical(comboMJnscoverPar, _sentinel) ? this.comboMJnscoverPar : comboMJnscoverPar as ComboMJnscoverParModel?,
			comboMWilayah: identical(comboMWilayah, _sentinel) ? this.comboMWilayah : comboMWilayah as ComboMWilayahModel?,
			comboMKabZonaGempa: identical(comboMKabZonaGempa, _sentinel) ? this.comboMKabZonaGempa : comboMKabZonaGempa as ComboMKabZonaGempaModel?,
		);
	}

	@override
	List<Object?> get props => [
		record,
		isLoading,
		isLoaded,
		isSaving,
		isSaved,
		hasFailure,
		returnData,
		comboMJnscoverPar,
		comboMWilayah,
		comboMKabZonaGempa,
	];
}
