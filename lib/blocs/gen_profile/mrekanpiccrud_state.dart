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
	final String? savedId;
	const MRekanPicCrudState(
			{this.record,
				this.isLoading = false,
				this.isLoaded = false,
				this.isSaving = false,
				this.isSaved = false,
				this.hasFailure = false,
				this.comboMJabatan,
				this.isFieldIsDefaultChanged = false,
				this.savedId,
			});

  static const _sentinel = Object();

	MRekanPicCrudState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		String? savedId,
		Object? comboMJabatan = _sentinel,
		bool? isFieldIsDefaultChanged
	}){
		return MRekanPicCrudState(
				record: identical(record, _sentinel) ? this.record : record as MRekanPicCrudModel?,
				isLoading: isLoading ?? this.isLoading,
				isLoaded: isLoaded ?? this.isLoaded,
				isSaving: isSaving ?? this.isSaving,
				isSaved: isSaved ?? this.isSaved,
				hasFailure: hasFailure ?? this.hasFailure,
				comboMJabatan: identical(comboMJabatan, _sentinel) ? this.comboMJabatan : comboMJabatan as ComboMJabatanModel?,
				savedId: savedId ?? this.savedId,
				isFieldIsDefaultChanged: isFieldIsDefaultChanged ?? this.isFieldIsDefaultChanged
		);
	}
	@override
	List<Object?> get props => [
		record,
		comboMJabatan,
		isLoading,
		isLoaded,
		isSaving,
		isSaved,
		hasFailure,
		savedId,
		isFieldIsDefaultChanged,
	];
}
