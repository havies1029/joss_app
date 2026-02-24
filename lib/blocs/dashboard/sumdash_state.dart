part of 'sumdash_bloc.dart';

class SumdashState extends Equatable {

	final SumdashModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool hasFailure;
	const SumdashState(
			{this.record,
				this.isLoading = false,
				this.isLoaded = false,
				this.hasFailure = false,
			});

	SumdashState copyWith({
		SumdashModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? hasFailure,
	}){
		return SumdashState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			hasFailure: hasFailure ?? this.hasFailure,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, hasFailure];
}