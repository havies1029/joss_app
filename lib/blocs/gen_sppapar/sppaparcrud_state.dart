part of 'sppaparcrud_bloc.dart';

class SppaparCrudState extends Equatable {

	final SppaparCrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboRMatauangModel? comboRMatauang;
	final ComboROkupasiModel? comboROkupasi;
	final ComboRKonstruksiojkModel? comboRKonstruksiojk;
	final ComboMBiindemnityOjkModel? comboMBiindemnityOjk;
	final ComboMKabZonaGempaModel? comboMKabZonaGempa;
	final ComboMWilayahModel? comboMWilayah;
	final ComboMTarifojkBanjirParModel? comboMTarifojkBanjirPar;
	final ComboRKodeposModel? comboRKodepos;
	const SppaparCrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboRMatauang,
		this.comboROkupasi,
		this.comboRKonstruksiojk,
		this.comboMBiindemnityOjk,
		this.comboMKabZonaGempa,
		this.comboMWilayah,
		this.comboMTarifojkBanjirPar,
		this.comboRKodepos,
});

  static const _sentinel = Object();

	SppaparCrudState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboRMatauang = _sentinel,
		Object? comboROkupasi = _sentinel,
		Object? comboRKonstruksiojk = _sentinel,
		Object? comboMBiindemnityOjk = _sentinel,
		Object? comboMKabZonaGempa = _sentinel,
		Object? comboMWilayah = _sentinel,
		Object? comboMTarifojkBanjirPar = _sentinel,
		Object? comboRKodepos = _sentinel,
	}){
		return SppaparCrudState(
			record: identical(record, _sentinel) ? this.record : record as SppaparCrudModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboRMatauang: identical(comboRMatauang, _sentinel) ? this.comboRMatauang : comboRMatauang as ComboRMatauangModel?,
			comboROkupasi: identical(comboROkupasi, _sentinel) ? this.comboROkupasi : comboROkupasi as ComboROkupasiModel?,
			comboRKonstruksiojk: identical(comboRKonstruksiojk, _sentinel) ? this.comboRKonstruksiojk : comboRKonstruksiojk as ComboRKonstruksiojkModel?,
			comboMBiindemnityOjk: identical(comboMBiindemnityOjk, _sentinel) ? this.comboMBiindemnityOjk : comboMBiindemnityOjk as ComboMBiindemnityOjkModel?,
			comboMKabZonaGempa: identical(comboMKabZonaGempa, _sentinel) ? this.comboMKabZonaGempa : comboMKabZonaGempa as ComboMKabZonaGempaModel?,
			comboMWilayah: identical(comboMWilayah, _sentinel) ? this.comboMWilayah : comboMWilayah as ComboMWilayahModel?,
			comboMTarifojkBanjirPar: identical(comboMTarifojkBanjirPar, _sentinel) ? this.comboMTarifojkBanjirPar : comboMTarifojkBanjirPar as ComboMTarifojkBanjirParModel?,
			comboRKodepos: identical(comboRKodepos, _sentinel) ? this.comboRKodepos : comboRKodepos as ComboRKodeposModel?,
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
		comboROkupasi,
		comboRKonstruksiojk,
		comboMBiindemnityOjk,
		comboMKabZonaGempa,
		comboMWilayah,
		comboMTarifojkBanjirPar,
		comboRKodepos,
	];
}
