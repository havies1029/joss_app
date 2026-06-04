part of 'management_polis_target_bloc.dart';

class ManagementPolisTargetState extends Equatable {
  final String? cobId;
  final String? statusId;
  final bool consumed;

  const ManagementPolisTargetState({
    this.cobId,
    this.statusId,
    this.consumed = true,
  });

  ManagementPolisTargetState copyWith({
    String? cobId,
    String? statusId,
    bool? consumed,
  }) {
    return ManagementPolisTargetState(
      cobId: cobId ?? this.cobId,
      statusId: statusId ?? this.statusId,
      consumed: consumed ?? this.consumed,
    );
  }

  @override
  List<Object?> get props => [
    cobId,
    statusId,
    consumed,
  ];
}