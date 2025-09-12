part of 'klaim2list_bloc.dart';

class Klaim2ListState extends Equatable {
  final ListStatus status;
  final List<Klaim2ListModel> items;
  final bool hasReachedMax;
  final int hal;
  final String viewMode;
  final String recordId;
  final String klaim1Id;

  const Klaim2ListState(
      {this.status = ListStatus.initial,
      this.items = const <Klaim2ListModel>[],
      this.hasReachedMax = false,
      this.hal = 0,
      this.viewMode = "",
      this.recordId = "",
      this.klaim1Id = ""});

  Klaim2ListState copyWith(
      {List<Klaim2ListModel>? items,
      bool? hasReachedMax,
      ListStatus? status,
      int? hal,
      String? viewMode,
      String? recordId,
      String? klaim1Id}) {
    return Klaim2ListState(
        items: items ?? this.items,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        status: status ?? this.status,
        hal: hal ?? this.hal,
        viewMode: viewMode ?? this.viewMode,
        recordId: recordId ?? this.recordId,
        klaim1Id: klaim1Id ?? this.klaim1Id);
  }

  @override
  List<Object> get props =>
      [status, items, hasReachedMax, hal, viewMode, recordId, klaim1Id];
}
