part of 'beritalaincari_bloc.dart';

abstract class BeritaLainCariEvents extends Equatable {
  const BeritaLainCariEvents();

  @override
  List<Object> get props => [];
}

class FetchBeritaLainCariEvent extends BeritaLainCariEvents {}

class RefreshBeritaLainCariEvent extends BeritaLainCariEvents {
  final int jenis;
  final String? berita1Id; // ⬅️ tambahkan ini

  const RefreshBeritaLainCariEvent(this.jenis, {this.berita1Id}); // ⬅️ gunakan di konstruktor


  @override
  List<Object> get props => [jenis];
}
