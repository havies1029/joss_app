part of 'klaimmvstatuscrud_bloc.dart';

class KlaimmvstatuscrudState extends Equatable {

	final KlaimmvstatuscrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
  final bool isComplete;
	const KlaimmvstatuscrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
    this.isComplete = false,
});

	KlaimmvstatuscrudState copyWith({
		KlaimmvstatuscrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
    bool? isComplete,
	}){
		return KlaimmvstatuscrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
      isComplete: isComplete ?? this.isComplete,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, record ?? '', isComplete];
}
