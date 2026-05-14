part of 'sppa2healthcari_bloc.dart';

class Sppa2healthCariState extends Equatable {
	final ListStatus status;
	final List<Sppa2healthCariModel> items;
	final bool hasReachedMax;
	final bool isFetching;
	final int hal;
	final String searchText;
	final String sppa1Id;
	final String queryKey;

	const Sppa2healthCariState({
		this.status = ListStatus.initial,
		this.items = const <Sppa2healthCariModel>[],
		this.hasReachedMax = false,
		this.isFetching = false,
		this.hal = 0,
		this.searchText = '',
		this.sppa1Id = '',
		this.queryKey = '',
	});

	const Sppa2healthCariState.success(List<Sppa2healthCariModel> items)
			: this(status: ListStatus.success, items: items);

	const Sppa2healthCariState.failure() : this(status: ListStatus.failure);

	Sppa2healthCariState copyWith({
		List<Sppa2healthCariModel>? items,
		bool? hasReachedMax,
		bool? isFetching,
		ListStatus? status,
		int? hal,
		String? searchText,
		String? sppa1Id,
		String? queryKey,
	}) {
		return Sppa2healthCariState(
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