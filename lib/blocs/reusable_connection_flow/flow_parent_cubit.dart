// lib/flows/flow_parent_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'flow_parent_state.dart';

class FlowParentCubit extends Cubit<FlowParentState> {
  FlowParentCubit()
      : super(
    FlowParentState(
      currentActiveIndex: 0,
      steps: const [
        FlowStep(index: 0, type: "form", sectionKey: "calmv1", isActive: true),
        FlowStep(index: 1, type: "form", sectionKey: "calmv2"),
        FlowStep(index: 2, type: "button", sectionKey: "hitungPremi"),
        FlowStep(index: 3, type: "form", sectionKey: "calmv3"),
      ],
    ),
  );

  // ===========================================================
  // REQUEST OPEN STEP
  // ===========================================================
  void requestOpenStep(int targetIndex) {
    final current = state.currentActiveIndex;

    // 1) klik step aktif
    if (targetIndex == current) {
      emit(state.copyWith(
        uiEvent: FlowUiEvent(
          type: FlowUiEventType.activateStep,
          stepIndex: current,
        ),
      ));
      return;
    }

    // 2) BACKWARD → bebas tanpa evaluasi
    if (targetIndex < current) {
      final steps = [...state.steps];
      for (var i = 0; i < steps.length; i++) {
        steps[i] = steps[i].copyWith(isActive: i == targetIndex);
      }
      emit(
        state.copyWith(
          steps: steps,
          currentActiveIndex: targetIndex,
          requestedIndex: null,
          uiEvent: const FlowUiEvent.none(), // ⛔ JANGAN ACTIVATE UI DI BACKWARD
        ),
      );

      return;
    }

    // 3) FORWARD strict → hanya current -> next
    if (targetIndex == current + 1) {
      emit(
        state.copyWith(
          requestedIndex: targetIndex,
          uiEvent: const FlowUiEvent.none(),
        ),
      );
      _evaluateCurrentBeforeLeave();
      return;
    }

    // 4) lainnya → loncat jauh
    return;
  }



  // ===========================================================
  // EVALUATE ANAK YANG SEDANG DI DALAM KAMAR MANDI
  // ===========================================================
  void _evaluateCurrentBeforeLeave() {
    final current = state.currentActiveIndex;
    final step = state.steps[current];

    // 1) Masih sabunan (tidak valid + belum punya id)
    if (!step.isValid && step.id == null) {
      emit(
        state.copyWith(
          uiEvent: FlowUiEvent(
            type: FlowUiEventType.validateStep,
            stepIndex: current,
          ),
        ),
      );
      return;
    }

    // 2) Sudah valid tapi belum save (form)
    if (step.isValid && step.id == null && step.type == "form") {
      emit(
        state.copyWith(
          uiEvent: FlowUiEvent(
            type: FlowUiEventType.saveStep,
            stepIndex: current,
          ),
        ),
      );
      return;
    }

    // 3) SUDAH PUNYA ID = dianggap valid
    if (step.id != null || step.type == "button") {
      _moveToRequestedStep();
      return;
    }

  }

  // ===========================================================
  // RETURN VALIDATION RESULT DARI ANAK
  // ===========================================================
  void onValidationResult({
    required int index,
    required bool isValid,
  }) {
    final steps = [...state.steps];
    steps[index] = steps[index].copyWith(isValid: isValid);

    emit(
      state.copyWith(
        steps: steps,
        uiEvent: const FlowUiEvent.none(),
      ),
    );

    if (!isValid) return;

    _evaluateCurrentBeforeLeave();
  }

  // ===========================================================
  // RETURN SAVE RESULT DARI ANAK
  // ===========================================================
  void onSaveResult({
    required int index,
    required String id,
  }) {
    final steps = [...state.steps];
    steps[index] = steps[index].copyWith(
      id: id,
      isValid: true,
      isCompleted: true,
    );

    emit(
      state.copyWith(
        steps: steps,
        uiEvent: const FlowUiEvent.none(),
      ),
    );

    _evaluateCurrentBeforeLeave();
  }

  // ===========================================================
  // BUTTON TRIGGER
  // ===========================================================
  void onButtonTriggered({
    required int index,
    required Map<String, dynamic> payload,
  }) {
    final steps = [...state.steps];
    steps[index] = steps[index].copyWith(
      isValid: true,
      isCompleted: true,
    );

    emit(
      state.copyWith(
        steps: steps,
        buttonPayload: payload,
      ),
    );

    _moveToRequestedStep(forceNextFrom: index);
  }

  // ===========================================================
  // PINDAH STEP
  // ===========================================================
  void _moveToRequestedStep({int? forceNextFrom}) {
    final current = state.currentActiveIndex;
    final steps = [...state.steps];

    final target = state.requestedIndex ??
        ((forceNextFrom != null) ? forceNextFrom + 1 : current + 1);

    if (target < 0 || target >= steps.length) return;

    // Matikan semua step, hidupkan step target
    for (var i = 0; i < steps.length; i++) {
      steps[i] = steps[i].copyWith(isActive: i == target);
    }

    // ====================================================================================
    // SOLUSI 2 — Setelah payload dipakai, HAPUS buttonPayload agar button bisa dipakai lagi
    // ====================================================================================

    final payloadToSend = (target == 3) ? state.buttonPayload : null;

    emit(
      state.copyWith(
        steps: steps,
        currentActiveIndex: target,
        requestedIndex: null,
        buttonPayload: (target == 3) ? null : state.buttonPayload,
        uiEvent: FlowUiEvent(
          type: FlowUiEventType.activateStep,
          stepIndex: target,
          payload: payloadToSend,
        ),
      ),
    );

    // ====================================================================================
    // SOLUSI 3 — Auto RESET FLOW jika mencapai step terakhir & completed
    // ====================================================================================
    // if (target == steps.length - 1 && steps[target].isCompleted == true) {
    //   _autoResetFlow();
    // }
    if (target == steps.length - 1 && steps[target].isCompleted == true) {
      notifyFlowCompleted();
    }
  }

  // ===========================================================
  // SOLUSI 4 — RESET FLOW (BIAR BISA LOOPING)
  // ===========================================================
  void _autoResetFlow() {
    final resetSteps = <FlowStep>[];

    for (final s in state.steps) {
      resetSteps.add(
        s.copyWith(
          isActive: s.index == 0,
          isValid: (s.id != null), // kalau punya id = valid
          isCompleted: false,
        ),
      );
    }

    emit(
      state.copyWith(
        steps: resetSteps,
        currentActiveIndex: 0,
        requestedIndex: null,
        buttonPayload: null,
        uiEvent: FlowUiEvent(
          type: FlowUiEventType.activateStep,
          stepIndex: 0,
        ),
      ),
    );
  }

  void notifyFlowCompleted() {
    emit(
      state.copyWith(
        uiEvent: FlowUiEvent(
          type: FlowUiEventType.flowCompleted,
        ),
      ),
    );
  }
}