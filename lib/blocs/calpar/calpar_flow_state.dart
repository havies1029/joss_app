part of 'calpar_flow_bloc.dart';

class CalparFlowState extends Equatable {
  final bool step2Triggered;
  final bool step3Triggered;
  final bool step4Triggered;
  const CalparFlowState({
    this.step2Triggered = false,
    this.step3Triggered = false,
    this.step4Triggered = false,
  });

  CalparFlowState copyWith({
    bool? step2Triggered,
    bool? step3Triggered,
    bool? step4Triggered,
  }) {
    return CalparFlowState(
      step2Triggered: step2Triggered ?? this.step2Triggered,
      step3Triggered: step3Triggered ?? this.step3Triggered,
      step4Triggered: step4Triggered ?? this.step4Triggered,
    );
  }

  @override
  List<Object?> get props => [step2Triggered, step3Triggered, step4Triggered];
}
