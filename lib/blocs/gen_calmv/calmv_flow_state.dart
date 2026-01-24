part of 'calmv_flow_bloc.dart';

class CalmvFlowState extends Equatable {
  final bool step2Triggered;
  final bool step3Triggered;

  const CalmvFlowState({
    this.step2Triggered = false,
    this.step3Triggered = false,
  });

  CalmvFlowState copyWith({
    bool? step2Triggered,
    bool? step3Triggered,
  }) {
    return CalmvFlowState(
      step2Triggered: step2Triggered ?? this.step2Triggered,
      step3Triggered: step3Triggered ?? this.step3Triggered,
    );
  }

  @override
  List<Object?> get props => [step2Triggered, step3Triggered];
}
