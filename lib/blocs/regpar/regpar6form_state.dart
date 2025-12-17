part of 'regpar6form_bloc.dart';

class Regpar6FormState extends Equatable {

	final Regpar6FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	const Regpar6FormState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
});

	Regpar6FormState copyWith({
		Regpar6FormModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
	}){
		return Regpar6FormState(
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
