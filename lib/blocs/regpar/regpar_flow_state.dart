part of 'regpar_flow_bloc.dart';

class RegparFlowState extends Equatable {
  final bool step2Triggered;
  final bool step3Triggered;
  final bool step4Triggered;
  final bool step5Triggered;

  const RegparFlowState({
    this.step2Triggered = false,
    this.step3Triggered = false,
    this.step4Triggered = false,
    this.step5Triggered = false,
  });

  RegparFlowState copyWith({
    bool? step2Triggered,
    bool? step3Triggered,
    bool? step4Triggered,
    bool? step5Triggered,
  }) {
    return RegparFlowState(
      step2Triggered: step2Triggered ?? this.step2Triggered,
      step3Triggered: step3Triggered ?? this.step3Triggered,
      step4Triggered: step4Triggered ?? this.step4Triggered,
      step5Triggered: step5Triggered ?? this.step5Triggered,
    );
  }

  @override
  List<Object?> get props => [
    step2Triggered,
    step3Triggered,
    step4Triggered,
    step5Triggered,
  ];
}
