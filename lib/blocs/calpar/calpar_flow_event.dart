part of 'calpar_flow_bloc.dart';

abstract class CalparFlowEvent extends Equatable {
  const CalparFlowEvent();

  @override
  List<Object?> get props => [];
}

class CalparFlowStartEvent extends CalparFlowEvent {
  const CalparFlowStartEvent();
}

class CalparFlowEnsureCalpar2Event extends CalparFlowEvent {
  const CalparFlowEnsureCalpar2Event();
}

class CalparFlowEnsureCalpar3Event extends CalparFlowEvent {
  const CalparFlowEnsureCalpar3Event();
}


class CalparFlowHitungPremiIfReadyEvent extends CalparFlowEvent {
  const CalparFlowHitungPremiIfReadyEvent();
}
