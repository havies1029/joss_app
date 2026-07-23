part of 'berita3cari_bloc.dart';

class Berita3CariState extends Equatable {
  final ListStatus status;
  final List<Berita3CariModel> items;
  final bool hasReachedMax;
  final String berita1Id;
  final Map<String, List<Berita3CariModel>> cache;

  const Berita3CariState({
    this.status = ListStatus.initial,
    this.items = const <Berita3CariModel>[],
    this.hasReachedMax = false,
    this.berita1Id = "",
    this.cache = const <String, List<Berita3CariModel>>{},
  });

  const Berita3CariState.success(List<Berita3CariModel> items)
      : this(status: ListStatus.success, items: items);

  const Berita3CariState.failure() : this(status: ListStatus.failure);

  Berita3CariState copyWith({
    List<Berita3CariModel>? items,
    bool? hasReachedMax,
    ListStatus? status,
    String? berita1Id,
    Map<String, List<Berita3CariModel>>? cache,
  }) {
    return Berita3CariState(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      berita1Id: berita1Id ?? this.berita1Id,
      cache: cache ?? this.cache,
    );
  }

  @override
  List<Object> get props => [status, items, hasReachedMax, berita1Id, cache];
}
