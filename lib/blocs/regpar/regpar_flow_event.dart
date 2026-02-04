part of 'regpar_flow_bloc.dart';

abstract class RegparFlowEvent extends Equatable {
  const RegparFlowEvent();

  @override
  List<Object?> get props => [];
}

class RegparFlowStartEvent extends RegparFlowEvent {
  const RegparFlowStartEvent();
}

class RegparFlowEnsureRegpar2Event extends RegparFlowEvent {
  const RegparFlowEnsureRegpar2Event();
}

class RegparFlowEnsureRegpar3Event extends RegparFlowEvent {
  const RegparFlowEnsureRegpar3Event();
}

class RegparFlowEnsureRegpar4Event extends RegparFlowEvent {
  const RegparFlowEnsureRegpar4Event();
}


class RegparFlowHitungPremiIfReadyEvent extends RegparFlowEvent {
  const RegparFlowHitungPremiIfReadyEvent();
}
