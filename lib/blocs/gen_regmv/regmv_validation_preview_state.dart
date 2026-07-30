part of 'regmv_validation_preview_bloc.dart';

class RegmvValidationPreviewState extends Equatable {
  final bool isChecking;
  final bool isChecked;
  final bool hasFailure;
  final RegmvValidationPreviewResponseModel? response;

  const RegmvValidationPreviewState({
    this.isChecking = false,
    this.isChecked = false,
    this.hasFailure = false,
    this.response,
  });

  RegmvValidationPreviewState copyWith({
    bool? isChecking,
    bool? isChecked,
    bool? hasFailure,
    RegmvValidationPreviewResponseModel? response,
  }) {
    return RegmvValidationPreviewState(
      isChecking: isChecking ?? this.isChecking,
      isChecked: isChecked ?? this.isChecked,
      hasFailure: hasFailure ?? this.hasFailure,
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [
        isChecking,
        isChecked,
        hasFailure,
        response,
      ];
}
