part of 'mrekancontactcrud_bloc.dart';

class MRekanContactCrudState extends Equatable {
	final MRekanContactCrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMPropinsiModel? comboMPropinsi;
	final ComboMKotaModel? comboMKota;
	final ComboRKodeposModel? comboRKodepos;

	const MRekanContactCrudState({
		this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMPropinsi,
		this.comboMKota,
		this.comboRKodepos,
	});

	static const _unset = Object();

	MRekanContactCrudState copyWith({
		Object? record = _unset,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMPropinsi = _unset,
		Object? comboMKota = _unset,
		Object? comboRKodepos = _unset,
	}) {
		return MRekanContactCrudState(
			record: record == _unset ? this.record : record as MRekanContactCrudModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMPropinsi: comboMPropinsi == _unset
					? this.comboMPropinsi
					: comboMPropinsi as ComboMPropinsiModel?,
			comboMKota: comboMKota == _unset
					? this.comboMKota
					: comboMKota as ComboMKotaModel?,
			comboRKodepos: comboRKodepos == _unset
					? this.comboRKodepos
					: comboRKodepos as ComboRKodeposModel?,
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
		comboMPropinsi,
		comboMKota,
		comboRKodepos,
	];
}