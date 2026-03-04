part of 'beritakecilcari_bloc.dart';

abstract class BeritaKecilCariEvents extends Equatable {
  const BeritaKecilCariEvents();

  @override
  List<Object> get props => [];
}

class FetchBeritaKecilCariEvent extends BeritaKecilCariEvents {}

class RefreshBeritaKecilCariEvent extends BeritaKecilCariEvents {
  final int jenis;
  final String? berita1Id; // ⬅️ tambahkan
  const RefreshBeritaKecilCariEvent(this.jenis, {this.berita1Id});

  @override
  List<Object> get props => [jenis];
}
