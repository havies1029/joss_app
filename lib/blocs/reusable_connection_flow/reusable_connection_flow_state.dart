import 'package:flutter/foundation.dart';

@immutable
class ReusableConnectionFlowState {
  /// Stage aktif saat ini (bisa "form1", "form2", "form3", dsb)
  final String activeStage;

  /// ID utama yang dihasilkan dari Form1 (contoh: calmv1_id)
  final String? activeId;

  /// Data yang dibagikan ke form berikutnya (misal hasil premi)
  final List<String>? sharedData;

  /// Menandakan sedang transisi antar form
  final bool isTransitioning;

  /// Loading global (misal nunggu auto-save)
  final bool isLoading;

  /// Error global antar form
  final bool hasError;

  /// Pesan error
  final String? errorMessage;

  /// --- Status validasi & penyimpanan Form1 ---
  final bool isForm1Valid;
  final bool isForm1Saving;
  final bool isForm1Saved;

  const ReusableConnectionFlowState({
    this.activeStage = "form1",
    this.activeId,
    this.sharedData,
    this.isTransitioning = false,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.isForm1Valid = false,
    this.isForm1Saving = false,
    this.isForm1Saved = false,
  });

  ReusableConnectionFlowState copyWith({
    String? activeStage,
    String? activeId,
    List<String>? sharedData,
    bool? isTransitioning,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    bool? isForm1Valid,
    bool? isForm1Saving,
    bool? isForm1Saved,
  }) {
    return ReusableConnectionFlowState(
      activeStage: activeStage ?? this.activeStage,
      activeId: activeId ?? this.activeId,
      sharedData: sharedData ?? this.sharedData,
      isTransitioning: isTransitioning ?? this.isTransitioning,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      isForm1Valid: isForm1Valid ?? this.isForm1Valid,
      isForm1Saving: isForm1Saving ?? this.isForm1Saving,
      isForm1Saved: isForm1Saved ?? this.isForm1Saved,
    );
  }
}
