part of 'trslogcari_bloc.dart';

class TrslogCariState extends Equatable {

	final ListStatus status;
	final List<TrslogCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String searchText;

	const TrslogCariState(
		{this.status = ListStatus.initial,
		this.items = const <TrslogCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
    this.searchText = ''});

	const TrslogCariState.success(List<TrslogCariModel> items)
			: this(status: ListStatus.success, items: items);

	const TrslogCariState.failure() : this(status: ListStatus.failure);

	TrslogCariState copyWith(
		{List<TrslogCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
    String? searchText}) {
		return TrslogCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
      searchText: searchText ?? this.searchText);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, searchText];
}
