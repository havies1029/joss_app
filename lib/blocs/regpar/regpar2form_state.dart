part of 'regpar2form_bloc.dart';

class Regpar2FormState extends Equatable {

	final Regpar2FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboROkupasiModel? comboROkupasi;
	final ComboRKonstruksiojkModel? comboRKonstruksiojk;
	final ComboMPropinsiModel? comboMPropinsi;
	final ComboMKotaModel? comboMKota;
	final ComboMKecamatanModel? comboMKecamatan;
	final ComboMKelurahanModel? comboMKelurahan;
	const Regpar2FormState(
			{this.record,
				this.isLoading = false,
				this.isLoaded = false,
				this.isSaving = false,
				this.isSaved = false,
				this.hasFailure = false,
				this.comboROkupasi,
				this.comboRKonstruksiojk,
				this.comboMPropinsi,
				this.comboMKota,
				this.comboMKecamatan,
				this.comboMKelurahan,
			});

  static const _sentinel = Object();

	Regpar2FormState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboROkupasi = _sentinel,
		Object? comboRKonstruksiojk = _sentinel,
		Object? comboMPropinsi = _sentinel,
		Object? comboMKota = _sentinel,
		Object? comboMKecamatan = _sentinel,
		Object? comboMKelurahan = _sentinel,
	}){
		return Regpar2FormState(
			record: identical(record, _sentinel) ? this.record : record as Regpar2FormModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboROkupasi: identical(comboROkupasi, _sentinel) ? this.comboROkupasi : comboROkupasi as ComboROkupasiModel?,
			comboRKonstruksiojk: identical(comboRKonstruksiojk, _sentinel) ? this.comboRKonstruksiojk : comboRKonstruksiojk as ComboRKonstruksiojkModel?,
			comboMPropinsi: identical(comboMPropinsi, _sentinel) ? this.comboMPropinsi : comboMPropinsi as ComboMPropinsiModel?,
			comboMKota: identical(comboMKota, _sentinel) ? this.comboMKota : comboMKota as ComboMKotaModel?,
			comboMKecamatan: identical(comboMKecamatan, _sentinel) ? this.comboMKecamatan : comboMKecamatan as ComboMKecamatanModel?,
			comboMKelurahan: identical(comboMKelurahan, _sentinel) ? this.comboMKelurahan : comboMKelurahan as ComboMKelurahanModel?,
		);
	}

	@override
	List<Object?> get props => [record ?? '', isLoading, isLoaded, isSaving, isSaved, hasFailure, comboROkupasi ?? '', comboRKonstruksiojk ?? '', comboMPropinsi ?? '', comboMKota ?? '', comboMKecamatan ?? '', comboMKelurahan ?? ''];
}
