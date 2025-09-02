part of 'galleryeventcari_bloc.dart';

class GalleryeventCariState extends Equatable {

	final ListStatus status;
	final List<GalleryeventCariModel> items;
	final bool hasReachedMax;
	const GalleryeventCariState(
		{this.status = ListStatus.initial,
		this.items = const <GalleryeventCariModel>[],
		this.hasReachedMax = false,
		});

	const GalleryeventCariState.success(List<GalleryeventCariModel> items)
			: this(status: ListStatus.success, items: items);

	const GalleryeventCariState.failure() : this(status: ListStatus.failure);

	GalleryeventCariState copyWith(
		{List<GalleryeventCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		}){
		return GalleryeventCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax];
}
