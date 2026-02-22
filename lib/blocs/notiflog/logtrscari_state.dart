part of 'logtrscari_bloc.dart';

class LogtrscariState extends Equatable {
	final ListStatus status;
	final List<LogtrscariModel> items;
	final bool hasReachedMax;
	final String groupLogId;
	final int hal;
	final bool isLoadingMore;
	const LogtrscariState({
		this.status = ListStatus.initial,
		this.items = const <LogtrscariModel>[],
		this.hasReachedMax = false,
		this.groupLogId = '',
		this.hal = 0,
		this.isLoadingMore = false,
	});

	const LogtrscariState.success(List<LogtrscariModel> items)
			: this(status: ListStatus.success, items: items);

	const LogtrscariState.failure()
			: this(status: ListStatus.failure);

	LogtrscariState copyWith({
		List<LogtrscariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		String? groupLogId,
		int? hal,
		bool? isLoadingMore,
	}) {
		return LogtrscariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			groupLogId: groupLogId ?? this.groupLogId,
			hal: hal ?? this.hal,
			isLoadingMore: isLoadingMore ?? this.isLoadingMore,
		);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, groupLogId, hal, isLoadingMore];
}