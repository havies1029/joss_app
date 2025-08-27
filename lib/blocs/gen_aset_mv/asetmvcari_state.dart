part of 'asetmvcari_bloc.dart';

class AsetMvCariState extends Equatable {

	final ListStatus status;
	final List<AsetMvCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String searchText;
  final String statusId;

	const AsetMvCariState(
		{this.status = ListStatus.initial,
		this.items = const <AsetMvCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
		this.searchText = '',
		this.statusId = ''});

	const AsetMvCariState.success(List<AsetMvCariModel> items)
			: this(status: ListStatus.success, items: items);

	const AsetMvCariState.failure() : this(status: ListStatus.failure);

	AsetMvCariState copyWith(
		{List<AsetMvCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
		String? searchText,
		String? statusId}) {
		return AsetMvCariState(
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
