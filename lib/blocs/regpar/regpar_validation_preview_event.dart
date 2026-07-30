part of 'regpar_validation_preview_bloc.dart';

abstract class RegparValidationPreviewEvent extends Equatable {
  const RegparValidationPreviewEvent();

  @override
  List<Object?> get props => [];
}

class RegparValidationPreviewCheckEvent extends RegparValidationPreviewEvent {
  final RegparValidationPreviewRequestModel record;

  const RegparValidationPreviewCheckEvent({required this.record});

  @override
  List<Object?> get props => [record];
}

class RegparValidationPreviewResetEvent extends RegparValidationPreviewEvent {
  const RegparValidationPreviewResetEvent();
}
