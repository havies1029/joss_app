part of 'regreaktif1_bloc.dart';

class Regreaktif1State extends Equatable {

	final Regreaktif1Model? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	const Regreaktif1State(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
});

	Regreaktif1State copyWith({
		Regreaktif1Model? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
	}){
		return Regreaktif1State(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
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
	];
}
