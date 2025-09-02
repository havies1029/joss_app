part of 'galleryeventcari_bloc.dart';

abstract class GalleryeventCariEvents extends Equatable {
	const GalleryeventCariEvents();

	@override
	List<Object> get props => [];
}

class FetchGalleryeventCariEvent extends GalleryeventCariEvents {}

class RefreshGalleryeventCariEvent extends GalleryeventCariEvents {}

