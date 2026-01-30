part of 'asettrackcari_bloc.dart';

class AsettrackCariState extends Equatable {

	final ListStatus status;
	final List<AsettrackCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String searchText;

	const AsettrackCariState(
		{this.status = ListStatus.initial,
		this.items = const <AsettrackCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
    this.searchText = ''});

	const AsettrackCariState.success(List<AsettrackCariModel> items)
			: this(status: ListStatus.success, items: items);

	const AsettrackCariState.failure() : this(status: ListStatus.failure);

	AsettrackCariState copyWith(
		{List<AsettrackCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
    String? searchText
    }) {
		return AsettrackCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
      searchText: searchText ?? this.searchText,
      );
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, searchText];
}
