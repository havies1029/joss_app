// lib/flows/flow_parent_state.dart
import 'package:equatable/equatable.dart';

class FlowStep extends Equatable {
  final int index;
  final String type; // "form" | "button"
  final String sectionKey;

  final String? id;          // null = belum save
  final bool isValid;        // hasil validasi terakhir
  final bool isCompleted;    // sudah save / trigger
  final bool isActive;       // sedang dibuka di UI

  const FlowStep({
    required this.index,
    required this.type,
    required this.sectionKey,
    this.id,
    this.isValid = false,
    this.isCompleted = false,
    this.isActive = false,
  });

  FlowStep copyWith({
    String? id,
    bool? isValid,
    bool? isCompleted,
    bool? isActive,
  }) {
    return FlowStep(
      index: index,
      type: type,
      sectionKey: sectionKey,
      id: id ?? this.id,
      isValid: isValid ?? this.isValid,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [index, type, sectionKey, id, isValid, isCompleted, isActive];
}

/// Event kecil untuk menginstruksikan UI / anak
enum FlowUiEventType {
  none,
  validateStep,
  saveStep,
  activateStep,
  injectPayloadToStep,
  flowCompleted,
}

class FlowUiEvent extends Equatable {
  final FlowUiEventType type;
  final int? stepIndex;
  final Map<String, dynamic>? payload;

  const FlowUiEvent({
    this.type = FlowUiEventType.none,
    this.stepIndex,
    this.payload,
  });

  const FlowUiEvent.none()
      : type = FlowUiEventType.none,
        stepIndex = null,
        payload = null;

  @override
  List<Object?> get props => [type, stepIndex, payload];
}

class FlowParentState extends Equatable {
  final List<FlowStep> steps;
  final int currentActiveIndex;
  final int? requestedIndex;
  final FlowUiEvent uiEvent;
  final Map<String, dynamic>? buttonPayload;

  const FlowParentState({
    required this.steps,
    required this.currentActiveIndex,
    this.requestedIndex,
    this.uiEvent = const FlowUiEvent.none(),
    this.buttonPayload,
  });

  FlowParentState copyWith({
    List<FlowStep>? steps,
    int? currentActiveIndex,
    int? requestedIndex,
    FlowUiEvent? uiEvent,
    Map<String, dynamic>? buttonPayload,
  }) {
    return FlowParentState(
      steps: steps ?? this.steps,
      currentActiveIndex: currentActiveIndex ?? this.currentActiveIndex,
      requestedIndex: requestedIndex,
      uiEvent: uiEvent ?? const FlowUiEvent.none(),
      buttonPayload: buttonPayload ?? this.buttonPayload,
    );
  }

  @override
  List<Object?> get props => [
    steps,
    currentActiveIndex,
    requestedIndex,
    uiEvent,
    buttonPayload,
  ];
}
