part of 'rekanpiccrud_bloc.dart';

class RekanPicCrudState extends Equatable {

	final RekanPicCrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	const RekanPicCrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
});

	RekanPicCrudState copyWith({
		RekanPicCrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
	}){
		return RekanPicCrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
