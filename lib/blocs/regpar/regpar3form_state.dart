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

  static const _sentinel = Object();

	Regpar3FormState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMJnscoverPar = _sentinel,
		Object? comboMWilayah = _sentinel,
		Object? comboMKabZonaGempa = _sentinel,
	}){
		return Regpar3FormState(
			record: identical(record, _sentinel) ? this.record : record as Regpar3FormModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMJnscoverPar: identical(comboMJnscoverPar, _sentinel) ? this.comboMJnscoverPar : comboMJnscoverPar as ComboMJnscoverParModel?,
			comboMWilayah: identical(comboMWilayah, _sentinel) ? this.comboMWilayah : comboMWilayah as ComboMWilayahModel?,
			comboMKabZonaGempa: identical(comboMKabZonaGempa, _sentinel) ? this.comboMKabZonaGempa : comboMKabZonaGempa as ComboMKabZonaGempaModel?,
		);
	}

	@override
	List<Object?> get props => [record ?? '', isLoading, isLoaded, isSaving, isSaved, hasFailure, comboMJnscoverPar ?? '', comboMWilayah ?? '', comboMKabZonaGempa ?? ''];
}