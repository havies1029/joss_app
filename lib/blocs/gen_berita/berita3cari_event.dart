part of 'berita3cari_bloc.dart';

abstract class Berita3CariEvents extends Equatable {
  const Berita3CariEvents();

  @override
  List<Object> get props => [];
}

class FetchBerita3CariEvent extends Berita3CariEvents {
  final String berita1Id;

  const FetchBerita3CariEvent({required this.berita1Id});

  @override
  List<Object> get props => [berita1Id];
}

class RefreshBerita3CariEvent extends Berita3CariEvents {
  final String berita1Id;

  const RefreshBerita3CariEvent({required this.berita1Id});

  @override
  List<Object> get props => [berita1Id];
}
