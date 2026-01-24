part of 'calmv_flow_bloc.dart';

abstract class CalmvFlowEvent extends Equatable {
  const CalmvFlowEvent();

  @override
  List<Object?> get props => [];
}

class CalmvFlowStartEvent extends CalmvFlowEvent {
  const CalmvFlowStartEvent();
}

class CalmvFlowEnsureCalmv2Event extends CalmvFlowEvent {
  const CalmvFlowEnsureCalmv2Event();
}

class CalmvFlowHitungPremiIfReadyEvent extends CalmvFlowEvent {
  const CalmvFlowHitungPremiIfReadyEvent();
}
