part of 'regmv_upload_foto_acc_bloc.dart';

abstract class RegmvUploadFotoAccState extends Equatable {
  const RegmvUploadFotoAccState();

  @override
  List<Object?> get props => [];
}

class UploadFotoAccInitial extends RegmvUploadFotoAccState {}

class UploadFotoAccPreview extends RegmvUploadFotoAccState {
  final Uint8List imageBytes;
  final String fileName;
  const UploadFotoAccPreview(this.imageBytes, this.fileName);

  @override
  List<Object?> get props => [imageBytes, fileName];
}

class UploadFotoAccLoading extends RegmvUploadFotoAccState {}

class UploadFotoAccSuccess extends RegmvUploadFotoAccState {}

class UploadFotoAccFailure extends RegmvUploadFotoAccState {
  final String error;

  const UploadFotoAccFailure(this.error);

  @override
  List<Object?> get props => [error];
}
