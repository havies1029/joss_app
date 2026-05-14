part of 'sppa2parcari_bloc.dart';

class Sppa2parCariState extends Equatable {
	final ListStatus status;
	final List<Sppa2parCariModel> items;
	final bool hasReachedMax;
	final bool isFetching;
	final int hal;
	final String searchText;
	final String sppa1Id;
	final String queryKey;

	const Sppa2parCariState({
		this.status = ListStatus.initial,
		this.items = const <Sppa2parCariModel>[],
		this.hasReachedMax = false,
		this.isFetching = false,
		this.hal = 0,
		this.searchText = '',
		this.sppa1Id = '',
		this.queryKey = '',
	});

	Sppa2parCariState copyWith({
		List<Sppa2parCariModel>? items,
		bool? hasReachedMax,
		bool? isFetching,
		ListStatus? status,
		int? hal,
		String? searchText,
		String? sppa1Id,
		String? queryKey,
	}) {
		return Sppa2parCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			isFetching: isFetching ?? this.isFetching,
			status: status ?? this.status,
			hal: hal ?? this.hal,
			searchText: searchText ?? this.searchText,
			sppa1Id: sppa1Id ?? this.sppa1Id,
			queryKey: queryKey ?? this.queryKey,
		);
	}

	@override
	List<Object> get props => [
		status,
		items,
		hasReachedMax,
		isFetching,
		hal,
		searchText,
		sppa1Id,
		queryKey,
	];
}