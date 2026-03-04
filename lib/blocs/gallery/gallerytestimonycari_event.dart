part of 'gallerytestimonycari_bloc.dart';

abstract class GallerytestimonyCariEvents extends Equatable {
	const GallerytestimonyCariEvents();

	@override
	List<Object> get props => [];
}

class FetchGallerytestimonyCariEvent extends GallerytestimonyCariEvents {}

class RefreshGallerytestimonyCariEvent extends GallerytestimonyCariEvents {}

