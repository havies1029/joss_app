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
	const MRekanContactCrudState(
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

	MRekanContactCrudState copyWith({
		MRekanContactCrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboMPropinsiModel? comboMPropinsi,
		ComboMKotaModel? comboMKota,
		ComboRKodeposModel? comboRKodepos,
	}){
		return MRekanContactCrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMPropinsi: comboMPropinsi?? this.comboMPropinsi,
			comboMKota: comboMKota?? this.comboMKota,
			comboRKodepos: comboRKodepos?? this.comboRKodepos,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
