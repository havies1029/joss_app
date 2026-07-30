part of 'regpar_validation_preview_bloc.dart';

class RegparValidationPreviewState extends Equatable {
  final bool isChecking;
  final bool isChecked;
  final bool hasFailure;
  final RegparValidationPreviewResponseModel? response;

  const RegparValidationPreviewState({
    this.isChecking = false,
    this.isChecked = false,
    this.hasFailure = false,
    this.response,
  });

  RegparValidationPreviewState copyWith({
    bool? isChecking,
    bool? isChecked,
    bool? hasFailure,
    RegparValidationPreviewResponseModel? response,
  }) {
    return RegparValidationPreviewState(
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
