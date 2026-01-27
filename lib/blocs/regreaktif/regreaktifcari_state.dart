part of 'regreaktifcari_bloc.dart';

class RegreaktifCariState extends Equatable {

	final ListStatus status;
	final List<RegreaktifCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String searchText;

	const RegreaktifCariState(
		{this.status = ListStatus.initial,
		this.items = const <RegreaktifCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
    this.searchText = ""});

	const RegreaktifCariState.success(List<RegreaktifCariModel> items)
			: this(status: ListStatus.success, items: items);

	const RegreaktifCariState.failure() : this(status: ListStatus.failure);

	RegreaktifCariState copyWith(
		{List<RegreaktifCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
    String? searchText}) {
		return RegreaktifCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
      searchText: searchText ?? this.searchText);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, searchText];
}
