part of 'sppaheader_bloc.dart';

class SppaHeaderState extends Equatable {

	final SppaHeaderModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool hasFailure;
	const SppaHeaderState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.hasFailure = false,
});

	SppaHeaderState copyWith({
		SppaHeaderModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? hasFailure,
	}){
		return SppaHeaderState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			hasFailure: hasFailure ?? this.hasFailure,
		);
	}

	@override
	List<Object?> get props => [record, isLoading, isLoaded, hasFailure];
}
