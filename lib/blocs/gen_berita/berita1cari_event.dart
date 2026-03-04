part of 'berita1cari_bloc.dart';

abstract class Berita1CariEvents extends Equatable {
	const Berita1CariEvents();

	@override
	List<Object> get props => [];
}

class FetchBerita1CariEvent extends Berita1CariEvents {}

class RefreshBerita1CariEvent extends Berita1CariEvents {
  final int jenis;
  final String? berita1Id; // ⬅️ tambahkan
  const RefreshBerita1CariEvent(this.jenis, {this.berita1Id});

  @override
  List<Object> get props => [jenis];
}

