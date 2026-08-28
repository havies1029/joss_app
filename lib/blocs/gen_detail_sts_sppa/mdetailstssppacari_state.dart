part of 'mdetailstssppacari_bloc.dart';

class MDetailStsSppaCariState extends Equatable {
  final ListStatus status;
  final List<MDetailStsSppaCariModel> items;
  final bool hasReachedMax;
  final String selectedDetailStsSppaId;
  final int statusChangeTick;

  const MDetailStsSppaCariState({
    this.status = ListStatus.initial,
    this.items = const <MDetailStsSppaCariModel>[],
    this.hasReachedMax = false,
    this.selectedDetailStsSppaId = '',
    this.statusChangeTick = 0,
  });

  const MDetailStsSppaCariState.success(List<MDetailStsSppaCariModel> items)
      : this(status: ListStatus.success, items: items);

  const MDetailStsSppaCariState.failure() : this(status: ListStatus.failure);

  MDetailStsSppaCariState copyWith({
    List<MDetailStsSppaCariModel>? items,
    bool? hasReachedMax,
    ListStatus? status,
    String? selectedDetailStsSppaId,
    int? statusChangeTick,
  }) {
    return MDetailStsSppaCariState(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      selectedDetailStsSppaId:
          selectedDetailStsSppaId ?? this.selectedDetailStsSppaId,
      statusChangeTick: statusChangeTick ?? this.statusChangeTick,
    );
  }

  @override
  List<Object> get props => [
        status,
        items,
        hasReachedMax,
        selectedDetailStsSppaId,
        statusChangeTick,
      ];
}
