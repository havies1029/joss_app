part of 'regmv_upload_stnk_bloc.dart';

abstract class RegmvUploadStnkState extends Equatable {
  const RegmvUploadStnkState();

  @override
  List<Object?> get props => [];
}

class UploadStnkInitial extends RegmvUploadStnkState {}

class UploadStnkPreview extends RegmvUploadStnkState {
  final Uint8List imageBytes;
  final String fileName;
  const UploadStnkPreview(this.imageBytes, this.fileName);

  @override
  List<Object?> get props => [imageBytes, fileName];
}

class UploadStnkLoading extends RegmvUploadStnkState {}

class UploadStnkSuccess extends RegmvUploadStnkState {}

class UploadStnkFailure extends RegmvUploadStnkState {
  final String error;

  const UploadStnkFailure(this.error);

  @override
  List<Object?> get props => [error];
}
