part of 'asetringkasancari_bloc.dart';

class AsetRingkasanCariState extends Equatable {
  final ListStatus status;
  final List<AsetRingkasanCariModel> items;
  final bool hasReachedMax;
  final int hal;
  final String searchText;
  final String statusId;

  final String queryKey;
  final bool isFetching;

  const AsetRingkasanCariState({
    this.status = ListStatus.initial,
    this.items = const <AsetRingkasanCariModel>[],
    this.hasReachedMax = false,
    this.hal = 0,
    this.searchText = "",
    this.statusId = "",
    this.queryKey = "",
    this.isFetching = false,
  });

  AsetRingkasanCariState copyWith({
    List<AsetRingkasanCariModel>? items,
    bool? hasReachedMax,
    ListStatus? status,
    int? hal,
    String? searchText,
    String? statusId,
    String? queryKey,
    bool? isFetching,
  }) {
    return AsetRingkasanCariState(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      hal: hal ?? this.hal,
      searchText: searchText ?? this.searchText,
      statusId: statusId ?? this.statusId,
      queryKey: queryKey ?? this.queryKey,
      isFetching: isFetching ?? this.isFetching,
    );
  }

  @override
  List<Object> get props => [
    status, items, hasReachedMax, hal, searchText, statusId, queryKey, isFetching
  ];
}