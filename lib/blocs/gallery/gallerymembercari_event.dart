part of 'gallerymembercari_bloc.dart';

abstract class GallerymemberCariEvents extends Equatable {
	const GallerymemberCariEvents();

	@override
	List<Object> get props => [];
}

class FetchGallerymemberCariEvent extends GallerymemberCariEvents {}

class RefreshGallerymemberCariEvent extends GallerymemberCariEvents {}

