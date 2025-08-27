part of 'asethealthcari_bloc.dart';

class AsetHealthCariState extends Equatable {

	final ListStatus status;
	final List<AsetHealthCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String searchText;
  final String statusId;

	const AsetHealthCariState(
		{this.status = ListStatus.initial,
		this.items = const <AsetHealthCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
		this.searchText = '',
		this.statusId = ''});

	const AsetHealthCariState.success(List<AsetHealthCariModel> items)
			: this(status: ListStatus.success, items: items);

	const AsetHealthCariState.failure() : this(status: ListStatus.failure);

	AsetHealthCariState copyWith(
		{List<AsetHealthCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
		String? searchText,
		String? statusId}) {
		return AsetHealthCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
			searchText: searchText ?? this.searchText,
			statusId: statusId ?? this.statusId);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, searchText, statusId];
}
