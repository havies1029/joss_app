part of 'gallerytestimonycari_bloc.dart';

class GallerytestimonyCariState extends Equatable {

	final ListStatus status;
	final List<GallerytestimonyCariModel> items;
	final bool hasReachedMax;
	const GallerytestimonyCariState(
		{this.status = ListStatus.initial,
		this.items = const <GallerytestimonyCariModel>[],
		this.hasReachedMax = false,
		});

	const GallerytestimonyCariState.success(List<GallerytestimonyCariModel> items)
			: this(status: ListStatus.success, items: items);

	const GallerytestimonyCariState.failure() : this(status: ListStatus.failure);

	GallerytestimonyCariState copyWith(
		{List<GallerytestimonyCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		}){
		return GallerytestimonyCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax];
}
