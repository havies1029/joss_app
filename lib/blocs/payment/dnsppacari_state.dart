part of 'dnsppacari_bloc.dart';

class DnsppaCariState extends Equatable {
  final String listcobId;
  final String currId;
  final String searchText;
  final int hal;
	final ListStatus status;
	final List<DnsppaCariModel> items;
	final bool hasReachedMax;
	const DnsppaCariState(
		{
      this.listcobId = "",
      this.currId = "",
      this.searchText = "",
      this.hal = 1,
      this.status = ListStatus.initial,
		this.items = const <DnsppaCariModel>[],
		this.hasReachedMax = false,
		});

	const DnsppaCariState.success(List<DnsppaCariModel> items)
			: this(status: ListStatus.success, items: items);

	const DnsppaCariState.failure() : this(status: ListStatus.failure);

	DnsppaCariState copyWith(
		{
      String? listcobId,
      String? currId,
      String? searchText,
      int? hal,
      List<DnsppaCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		}) {
		return DnsppaCariState(
      listcobId: listcobId ?? this.listcobId,
      currId: currId ?? this.currId,
      searchText: searchText ?? this.searchText,
      hal: hal ?? this.hal, 
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			);
	}

	@override
	List<Object> get props => [listcobId, currId, searchText, hal, status, items, hasReachedMax];
}
