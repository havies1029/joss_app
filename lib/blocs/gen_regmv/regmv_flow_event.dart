part of 'regmv_flow_bloc.dart';

abstract class RegmvFlowEvent extends Equatable {
  const RegmvFlowEvent();

  @override
  List<Object?> get props => [];
}

class RegmvFlowStartEvent extends RegmvFlowEvent {
  const RegmvFlowStartEvent();
}

class RegmvFlowEnsureRegmv2Event extends RegmvFlowEvent {
  const RegmvFlowEnsureRegmv2Event();
}

class RegmvFlowEnsureRegmv3Event extends RegmvFlowEvent {
  const RegmvFlowEnsureRegmv3Event();
}

class RegmvFlowHitungPremiIfReadyEvent extends RegmvFlowEvent {
  const RegmvFlowHitungPremiIfReadyEvent();
}
