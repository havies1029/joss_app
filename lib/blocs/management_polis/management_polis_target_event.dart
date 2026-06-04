part of 'management_polis_target_bloc.dart';

abstract class ManagementPolisTargetEvents extends Equatable {
  const ManagementPolisTargetEvents();

  @override
  List<Object?> get props => [];
}

class SetManagementPolisTargetEvent extends ManagementPolisTargetEvents {
  final String cobId;
  final String statusId;

  const SetManagementPolisTargetEvent({
    required this.cobId,
    required this.statusId,
  });

  @override
  List<Object?> get props => [
    cobId,
    statusId,
  ];
}

class ConsumeManagementPolisTargetEvent extends ManagementPolisTargetEvents {
  const ConsumeManagementPolisTargetEvent();
}