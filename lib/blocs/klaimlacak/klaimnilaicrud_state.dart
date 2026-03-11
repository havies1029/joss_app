part of 'klaimnilaicrud_bloc.dart';

class KlaimnilaicrudState extends Equatable {

	final KlaimnilaicrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
  final String klaimNilaiId;
	const KlaimnilaicrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
    this.klaimNilaiId = ""
});

	KlaimnilaicrudState copyWith({
		KlaimnilaicrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
    String? klaimNilaiId,
	}){
		return KlaimnilaicrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
      klaimNilaiId: klaimNilaiId ?? this.klaimNilaiId
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
		klaimNilaiId,
	];
}
