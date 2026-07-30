part of 'regmv_validation_preview_bloc.dart';

abstract class RegmvValidationPreviewEvent extends Equatable {
  const RegmvValidationPreviewEvent();

  @override
  List<Object?> get props => [];
}

class RegmvValidationPreviewCheckEvent extends RegmvValidationPreviewEvent {
  final RegmvValidationPreviewRequestModel record;

  const RegmvValidationPreviewCheckEvent({required this.record});

  @override
  List<Object?> get props => [record];
}

class RegmvValidationPreviewResetEvent extends RegmvValidationPreviewEvent {
  const RegmvValidationPreviewResetEvent();
}
