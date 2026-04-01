part of 'mrekan1crud_bloc.dart';

class MRekan1CrudState extends Equatable {

	final MRekan1CrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
  final bool isSetujuTC;
  final bool isDataGroup1Changed;
	const MRekan1CrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.isSetujuTC = false,
		this.isDataGroup1Changed = false,
});

	MRekan1CrudState copyWith({
		MRekan1CrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		bool? isSetujuTC,
    bool? isDataGroup1Changed,
	}){
		return MRekan1CrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			isSetujuTC: isSetujuTC ?? this.isSetujuTC,
      isDataGroup1Changed: isDataGroup1Changed ?? this.isDataGroup1Changed,
		);
	}

	@override
	List<Object?> get props => [isLoading, isLoaded, isSaving, isSaved,
    hasFailure, isSetujuTC, isDataGroup1Changed, record];
}
