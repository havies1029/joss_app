part of 'mrekanpiccrud_bloc.dart';

class MRekanPicCrudState extends Equatable {

	final MRekanPicCrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final bool isFieldIsDefaultChanged;
	final ComboMJabatanModel? comboMJabatan;
	const MRekanPicCrudState(
			{this.record,
				this.isLoading = false,
				this.isLoaded = false,
				this.isSaving = false,
				this.isSaved = false,
				this.hasFailure = false,
				this.comboMJabatan,
				this.isFieldIsDefaultChanged = false
			});

	MRekanPicCrudState copyWith({
		MRekanPicCrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboMJabatanModel? comboMJabatan,
		bool? isFieldIsDefaultChanged
	}){
		return MRekanPicCrudState(
				record: record ?? this.record,
				isLoading: isLoading ?? this.isLoading,
				isLoaded: isLoaded ?? this.isLoaded,
				isSaving: isSaving ?? this.isSaving,
				isSaved: isSaved ?? this.isSaved,
				hasFailure: hasFailure ?? this.hasFailure,
				comboMJabatan: comboMJabatan?? this.comboMJabatan,
				isFieldIsDefaultChanged: isFieldIsDefaultChanged ?? this.isFieldIsDefaultChanged
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, isFieldIsDefaultChanged];
}
