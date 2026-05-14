part of 'sppa2hullcari_bloc.dart';

class Sppa2hullCariState extends Equatable {

	final ListStatus status;
	final List<Sppa2hullCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String searchText;
  final String sppa1Id;

	const Sppa2hullCariState(
		{this.status = ListStatus.initial,
		this.items = const <Sppa2hullCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
    this.searchText = '',
    this.sppa1Id = ''});

	const Sppa2hullCariState.success(List<Sppa2hullCariModel> items)
			: this(status: ListStatus.success, items: items);

	const Sppa2hullCariState.failure() : this(status: ListStatus.failure);

	Sppa2hullCariState copyWith(
		{List<Sppa2hullCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
    String? searchText,
    String? sppa1Id}) {
		return Sppa2hullCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
      searchText: searchText ?? this.searchText,
      sppa1Id: sppa1Id ?? this.sppa1Id,);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, searchText, sppa1Id];
}
