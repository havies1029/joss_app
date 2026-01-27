part of 'regendorscari_bloc.dart';

class RegendorsCariState extends Equatable {

	final ListStatus status;
	final List<RegendorsCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String searchText;

	const RegendorsCariState(
		{this.status = ListStatus.initial,
		this.items = const <RegendorsCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
    this.searchText = ""});

	const RegendorsCariState.success(List<RegendorsCariModel> items)
			: this(status: ListStatus.success, items: items);

	const RegendorsCariState.failure() : this(status: ListStatus.failure);

	RegendorsCariState copyWith(
		{List<RegendorsCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
    String? searchText}) {
		return RegendorsCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
      searchText: searchText ?? this.searchText);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, searchText];
}
