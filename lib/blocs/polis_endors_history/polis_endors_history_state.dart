part of 'polis_endors_history_bloc.dart';

class PolisEndorsHistoryState extends Equatable {
  final ListStatus status;
  final List<PolisEndorsHistoryModel> items;
  final PolisEndorsHistoryCob? cob;
  final String polis2Id;
  final String searchText;
  final String queryKey;
  final int hal;
  final int totalRows;
  final bool hasReachedMax;
  final bool isFetching;
  final String errorMessage;

  const PolisEndorsHistoryState({
    this.status = ListStatus.initial,
    this.items = const <PolisEndorsHistoryModel>[],
    this.cob,
    this.polis2Id = '',
    this.searchText = '',
    this.queryKey = '',
    this.hal = 0,
    this.totalRows = 0,
    this.hasReachedMax = false,
    this.isFetching = false,
    this.errorMessage = '',
  });

  PolisEndorsHistoryState copyWith({
    ListStatus? status,
    List<PolisEndorsHistoryModel>? items,
    PolisEndorsHistoryCob? cob,
    String? polis2Id,
    String? searchText,
    String? queryKey,
    int? hal,
    int? totalRows,
    bool? hasReachedMax,
    bool? isFetching,
    String? errorMessage,
  }) {
    return PolisEndorsHistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      cob: cob ?? this.cob,
      polis2Id: polis2Id ?? this.polis2Id,
      searchText: searchText ?? this.searchText,
      queryKey: queryKey ?? this.queryKey,
      hal: hal ?? this.hal,
      totalRows: totalRows ?? this.totalRows,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetching: isFetching ?? this.isFetching,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        cob,
        polis2Id,
        searchText,
        queryKey,
        hal,
        totalRows,
        hasReachedMax,
        isFetching,
        errorMessage,
      ];
}
