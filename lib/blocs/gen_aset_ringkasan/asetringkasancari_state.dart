part of 'asetringkasancari_bloc.dart';

class AsetRingkasanCariState extends Equatable {
  final ListStatus status;
  final List<AsetRingkasanCariModel> items;
  final bool hasReachedMax;
  final int hal;
  final String searchText;
  final String statusId;

  const AsetRingkasanCariState(
      {this.status = ListStatus.initial,
      this.items = const <AsetRingkasanCariModel>[],
      this.hasReachedMax = false,
      this.hal = 0,
      this.searchText = "",
      this.statusId = ""});

  const AsetRingkasanCariState.success(List<AsetRingkasanCariModel> items)
      : this(status: ListStatus.success, items: items);

  const AsetRingkasanCariState.failure() : this(status: ListStatus.failure);

  AsetRingkasanCariState copyWith(
      {List<AsetRingkasanCariModel>? items,
      bool? hasReachedMax,
      ListStatus? status,
      int? hal,
      String? searchText,
      String? statusId
      }) {
    return AsetRingkasanCariState(
        items: items ?? this.items,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        status: status ?? this.status,
        hal: hal ?? this.hal,
        searchText: searchText ?? this.searchText,
        statusId: statusId ?? this.statusId
    );
  }

  @override
  List<Object> get props => [status, items, hasReachedMax, hal, searchText, statusId];
}
