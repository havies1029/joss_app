part of 'rekancontact_bloc.dart';

class RekanContactState extends Equatable {

	final RekanContactModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMPropinsiModel? comboMPropinsi;
	final ComboMKotaModel? comboMKota;
	final ComboRKodeposModel? comboRKodepos;
	const RekanContactState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMPropinsi,
		this.comboMKota,
		this.comboRKodepos,
});

  static const _sentinel = Object();

	RekanContactState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMPropinsi = _sentinel,
		Object? comboMKota = _sentinel,
		Object? comboRKodepos = _sentinel,
	}){
		return RekanContactState(
			record: identical(record, _sentinel) ? this.record : record as RekanContactModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMPropinsi: identical(comboMPropinsi, _sentinel) ? this.comboMPropinsi : comboMPropinsi as ComboMPropinsiModel?,
			comboMKota: identical(comboMKota, _sentinel) ? this.comboMKota : comboMKota as ComboMKotaModel?,
			comboRKodepos: identical(comboRKodepos, _sentinel) ? this.comboRKodepos : comboRKodepos as ComboRKodeposModel?,
		);
	}

	@override
	List<Object?> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, record ?? '', comboMPropinsi ?? '', comboMKota ?? '', comboRKodepos ?? ''];
}
