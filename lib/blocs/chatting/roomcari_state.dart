part of 'roomcari_bloc.dart';

class RoomCariState extends Equatable {

	final ListStatus status;
	final List<RoomCariModel> items;
	final bool hasReachedMax;
	final int hal;

	const RoomCariState(
		{this.status = ListStatus.initial,
		this.items = const <RoomCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0});

	const RoomCariState.success(List<RoomCariModel> items)
			: this(status: ListStatus.success, items: items);

	const RoomCariState.failure() : this(status: ListStatus.failure);

	RoomCariState copyWith(
		{List<RoomCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal}){
		return RoomCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal];
}
