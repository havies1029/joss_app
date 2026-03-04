part of 'dnsppamvcari_bloc.dart';

class DnsppamvCariState extends Equatable {
  final String sppa1Id;
  final String searchText;
	final ListStatus status;
	final List<DnsppamvCariModel> items;
	final bool hasReachedMax;
	final int hal;

	const DnsppamvCariState(
		{this.sppa1Id = "",
    this.searchText = "",
		this.status = ListStatus.initial,
		this.items = const <DnsppamvCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0});

	const DnsppamvCariState.success(List<DnsppamvCariModel> items)
			: this(status: ListStatus.success, items: items);

	const DnsppamvCariState.failure() : this(status: ListStatus.failure);

	DnsppamvCariState copyWith(
		{
      String? sppa1Id,
      String? searchText,
      List<DnsppamvCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal}){
		return DnsppamvCariState(
      sppa1Id: sppa1Id ?? this.sppa1Id,
      searchText: searchText ?? this.searchText,
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal);
	}

	@override
	List<Object> get props => [sppa1Id, searchText, status, items, hasReachedMax, hal];
}
