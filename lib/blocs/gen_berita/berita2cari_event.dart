part of 'berita2cari_bloc.dart';

abstract class Berita2CariEvents extends Equatable {
	const Berita2CariEvents();

	@override
	List<Object> get props => [];
}

class FetchBerita2CariEvent extends Berita2CariEvents {}

class RefreshBerita2CariEvent extends Berita2CariEvents {
  final String berita1Id;

  const RefreshBerita2CariEvent({required this.berita1Id}); // ✅ named parameter

  @override
  List<Object> get props => [berita1Id];
}

