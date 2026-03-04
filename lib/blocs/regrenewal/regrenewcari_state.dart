part of 'regrenewcari_bloc.dart';

class RegrenewCariState extends Equatable {

	final ListStatus status;
	final List<RegrenewCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String searchText;

	const RegrenewCariState(
		{this.status = ListStatus.initial,
		this.items = const <RegrenewCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
    this.searchText = ""});

	const RegrenewCariState.success(List<RegrenewCariModel> items)
			: this(status: ListStatus.success, items: items);

	const RegrenewCariState.failure() : this(status: ListStatus.failure);

	RegrenewCariState copyWith(
		{List<RegrenewCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
    String? searchText}){
		return RegrenewCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
      searchText: searchText ?? this.searchText);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, searchText];
}
