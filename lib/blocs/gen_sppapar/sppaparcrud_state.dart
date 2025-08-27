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

	SppaparCrudState copyWith({
		SppaparCrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboRMatauangModel? comboRMatauang,
		ComboROkupasiModel? comboROkupasi,
		ComboRKonstruksiojkModel? comboRKonstruksiojk,
		ComboMBiindemnityOjkModel? comboMBiindemnityOjk,
		ComboMKabZonaGempaModel? comboMKabZonaGempa,
		ComboMWilayahModel? comboMWilayah,
		ComboMTarifojkBanjirParModel? comboMTarifojkBanjirPar,
		ComboRKodeposModel? comboRKodepos,
	}){
		return SppaparCrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboRMatauang: comboRMatauang?? this.comboRMatauang,
			comboROkupasi: comboROkupasi?? this.comboROkupasi,
			comboRKonstruksiojk: comboRKonstruksiojk?? this.comboRKonstruksiojk,
			comboMBiindemnityOjk: comboMBiindemnityOjk?? this.comboMBiindemnityOjk,
			comboMKabZonaGempa: comboMKabZonaGempa?? this.comboMKabZonaGempa,
			comboMWilayah: comboMWilayah?? this.comboMWilayah,
			comboMTarifojkBanjirPar: comboMTarifojkBanjirPar?? this.comboMTarifojkBanjirPar,
			comboRKodepos: comboRKodepos?? this.comboRKodepos,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
