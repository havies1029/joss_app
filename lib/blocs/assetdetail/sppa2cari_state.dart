part of 'sppa2cari_bloc.dart';

class Sppa2CariState extends Equatable {

	final ListStatus status;
	final List<Sppa2CariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String searchText;

	const Sppa2CariState(
		{this.status = ListStatus.initial,
		this.items = const <Sppa2CariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
    this.searchText = ""});

	const Sppa2CariState.success(List<Sppa2CariModel> items, {String searchText = ""})
			: this(status: ListStatus.success, items: items, searchText: searchText);

	const Sppa2CariState.failure({String searchText = ""}) : this(status: ListStatus.failure, searchText: searchText);

	Sppa2CariState copyWith(
		{List<Sppa2CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
    String? searchText}){
		return Sppa2CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
      searchText: searchText ?? this.searchText);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, searchText];
}
