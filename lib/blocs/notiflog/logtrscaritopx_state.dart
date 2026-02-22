part of 'logtrscaritopx_bloc.dart';

class LogtrscaritopxState extends Equatable {

	final ListStatus status;
	final List<LogtrscariModel> items;
	final bool hasReachedMax;
	const LogtrscaritopxState(
		{this.status = ListStatus.initial,
		this.items = const <LogtrscariModel>[],
		this.hasReachedMax = false,
		});

	const LogtrscaritopxState.success(List<LogtrscariModel> items)
			: this(status: ListStatus.success, items: items);

	const LogtrscaritopxState.failure() : this(status: ListStatus.failure);

	LogtrscaritopxState copyWith(
		{List<LogtrscariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		}){
		return LogtrscaritopxState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax];
}
