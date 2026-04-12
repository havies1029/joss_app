part of 'notifeventcari_bloc.dart';

class NotifeventcariState extends Equatable {
	final ListStatus status;
	final List<NotifeventcariModel> items;
	final bool hasReachedMax;
	final int hal;

	final bool isLoadingMore; // ✅ tambah ini

	const NotifeventcariState({
		this.status = ListStatus.initial,
		this.items = const <NotifeventcariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
		this.isLoadingMore = false,
	});

  static const _sentinel = Object();

	NotifeventcariState copyWith({
		Object? items = _sentinel,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
		bool? isLoadingMore,
	}) {
		return NotifeventcariState(
			items: identical(items, _sentinel) ? this.items : items as List<NotifeventcariModel>,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
			isLoadingMore: isLoadingMore ?? this.isLoadingMore,
		);
	}

	@override
	List<Object?> get props => [status, items, hasReachedMax, hal, isLoadingMore];
}