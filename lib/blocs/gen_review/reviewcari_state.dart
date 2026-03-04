part of 'reviewcari_bloc.dart';

class ReviewCariState extends Equatable {

	final ListStatus status;
	final List<ReviewCariModel> items;
	final bool hasReachedMax;
	final int hal;
	const ReviewCariState(
		{this.status = ListStatus.initial,
		this.items = const <ReviewCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
		});

	const ReviewCariState.success(List<ReviewCariModel> items)
			: this(status: ListStatus.success, items: items);

	const ReviewCariState.failure() : this(status: ListStatus.failure);

	ReviewCariState copyWith(
		{List<ReviewCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
		}){
		return ReviewCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal];
}
