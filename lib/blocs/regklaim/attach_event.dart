part of 'attach_bloc.dart';

sealed class AttachEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickImageFromCamera extends AttachEvent {}

class PickFilesFromStorage extends AttachEvent {}

class RemoveAttachment extends AttachEvent {
  final String localId;
  RemoveAttachment(this.localId);

  @override
  List<Object?> get props => [localId];
}

class UploadOne extends AttachEvent {
  final String localId;
  final String regklaim1Id;
  UploadOne({required this.localId, required this.regklaim1Id});

  @override
  List<Object?> get props => [localId, regklaim1Id];
}

class RetryUpload extends AttachEvent {
  final String localId;
  final String regklaim1Id;
  RetryUpload({required this.localId, required this.regklaim1Id});

  @override
  List<Object?> get props => [localId, regklaim1Id];
}

class CancelUpload extends AttachEvent {
  final String localId;
  CancelUpload(this.localId);

  @override
  List<Object?> get props => [localId];
}

class _ProgressChanged extends AttachEvent {
  final String localId;
  final double progress;
  _ProgressChanged(this.localId, this.progress);

  @override
  List<Object?> get props => [localId, progress];
}
