part of 'regpar_upload_foto_object_bloc.dart';

abstract class RegparUploadFotoObjectState extends Equatable {
  const RegparUploadFotoObjectState();

  @override
  List<Object?> get props => [];
}

class UploadFotoObjectInitial extends RegparUploadFotoObjectState {}

class UploadFotoObjectPreview extends RegparUploadFotoObjectState {
  final Uint8List imageBytes;
  final String fileName;
  const UploadFotoObjectPreview(this.imageBytes, this.fileName);

  @override
  List<Object?> get props => [imageBytes, fileName];
}

class UploadFotoObjectListPreview extends RegparUploadFotoObjectState {
  final List<Uint8List> images;
  final List<String> fileNames;

  const UploadFotoObjectListPreview(this.images, this.fileNames);

  @override
  List<Object?> get props => [images, fileNames];
}

class UploadFotoObjectLoading extends RegparUploadFotoObjectState {}

class UploadFotoObjectSuccess extends RegparUploadFotoObjectState {}

class UploadFotoObjectFailure extends RegparUploadFotoObjectState {
  final String error;

  const UploadFotoObjectFailure(this.error);

  @override
  List<Object?> get props => [error];
}
