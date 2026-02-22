part of 'notifeventcari_bloc.dart';

class NotifeventcariState extends Equatable {

	final ListStatus status;
	final List<NotifeventcariModel> items;
	final bool hasReachedMax;
  final int hal;
	const NotifeventcariState(
		{this.status = ListStatus.initial,
		this.items = const <NotifeventcariModel>[],
		this.hasReachedMax = false,
    this.hal = 0,
		});

	const NotifeventcariState.success(List<NotifeventcariModel> items, int hal)
			: this(status: ListStatus.success, items: items, hal: hal);

	const NotifeventcariState.failure() : this(status: ListStatus.failure);

	NotifeventcariState copyWith(
		{List<NotifeventcariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    int? hal,
		}){
		return NotifeventcariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal];
}
