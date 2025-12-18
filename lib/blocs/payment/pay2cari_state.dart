part of 'pay2cari_bloc.dart';

class Pay2CariState extends Equatable {

	final ListStatus status;
	final List<Pay2CariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String ar1Id;

	const Pay2CariState(
		{this.status = ListStatus.initial,
		this.items = const <Pay2CariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
    this.ar1Id = ''});

	const Pay2CariState.success(List<Pay2CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Pay2CariState.failure() : this(status: ListStatus.failure);

	Pay2CariState copyWith(
		{List<Pay2CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
    String? ar1Id}){
		return Pay2CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
      ar1Id: ar1Id ?? this.ar1Id);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, ar1Id];
}
