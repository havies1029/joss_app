part of 'sppa2parcari_bloc.dart';

class Sppa2parCariState extends Equatable {

	final ListStatus status;
	final List<Sppa2parCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String searchText;
  final String sppa1Id; 

	const Sppa2parCariState(
		{this.status = ListStatus.initial,
		this.items = const <Sppa2parCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
    this.searchText = '',
    this.sppa1Id = ''});

	const Sppa2parCariState.success(List<Sppa2parCariModel> items)
			: this(status: ListStatus.success, items: items);

	const Sppa2parCariState.failure() : this(status: ListStatus.failure);

	Sppa2parCariState copyWith(
		{List<Sppa2parCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
    String? searchText,
    String? sppa1Id}){
		return Sppa2parCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
      searchText: searchText ?? this.searchText,
      sppa1Id: sppa1Id ?? this.sppa1Id);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, searchText, sppa1Id];
}
