import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/reusable_connection_flow/reusable_connection_flow_state.dart';

class ReusableConnectionFlow extends Cubit<ReusableConnectionFlowState> {
  ReusableConnectionFlow() : super(const ReusableConnectionFlowState());

  // --- Navigasi antar stage ---
  void moveTo(String stage, {String? id, List<String>? data}) {
    emit(state.copyWith(
      activeStage: stage,
      activeId: id ?? state.activeId,
      sharedData: data ?? state.sharedData,
      isTransitioning: true,
    ));

    debugPrint("🔄 Flow moved to $stage, activeId=${id ?? state.activeId}");

    Future.delayed(const Duration(milliseconds: 250), () {
      emit(state.copyWith(isTransitioning: false));
    });
  }

  // --- Form1 status reporting ---
  void markForm1Valid(bool value) {
    emit(state.copyWith(isForm1Valid: value));
    debugPrint("🧩 Flow: Form1 valid = $value");
  }

  void markForm1Saving() {
    emit(state.copyWith(isForm1Saving: true, isForm1Saved: false));
    debugPrint("💾 Flow: Form1 saving...");
  }

  void markForm1Saved(String id) {
    emit(state.copyWith(
      isForm1Saving: false,
      isForm1Saved: true,
      isForm1Valid: true,
      activeId: id,
    ));
    debugPrint("✅ Flow: Form1 saved (ID: $id)");
  }

  void resetForm1Status() {
    emit(state.copyWith(
      isForm1Valid: false,
      isForm1Saving: false,
      isForm1Saved: false,
    ));
    debugPrint("♻️ Flow: Form1 status reset");
  }

  // --- Form2 status (optional next phase) ---
  void onForm2Completed(List<String> premi) {
    moveTo("form3", data: premi);
    debugPrint("🎯 Flow: Form2 selesai, lanjut form3");
  }

  // --- Error handling ---
  void setError(String message) {
    emit(state.copyWith(hasError: true, errorMessage: message));
    debugPrint("❌ Flow error: $message");
  }

  // --- Reset & resume logic ---
  void reset() {
    emit(const ReusableConnectionFlowState());
    debugPrint("🔁 Flow reset");
  }

  void resume(String stage, String id) {
    emit(state.copyWith(activeStage: stage, activeId: id));
    debugPrint("🔁 Flow resumed ke $stage dengan id=$id");
  }
}
