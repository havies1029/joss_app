part of 'gallerymembercari_bloc.dart';

class GallerymemberCariState extends Equatable {

	final ListStatus status;
	final List<GallerymemberCariModel> items;
	final bool hasReachedMax;
	const GallerymemberCariState(
		{this.status = ListStatus.initial,
		this.items = const <GallerymemberCariModel>[],
		this.hasReachedMax = false,
		});

	const GallerymemberCariState.success(List<GallerymemberCariModel> items)
			: this(status: ListStatus.success, items: items);

	const GallerymemberCariState.failure() : this(status: ListStatus.failure);

	GallerymemberCariState copyWith(
		{List<GallerymemberCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		}){
		return GallerymemberCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax];
}
