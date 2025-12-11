part of 'regmv_upload_foto_mobil_bloc.dart';

abstract class RegmvUploadFotoMobilState extends Equatable {
  const RegmvUploadFotoMobilState();

  @override
  List<Object?> get props => [];
}

class UploadFotoMobilInitial extends RegmvUploadFotoMobilState {}

class UploadFotoMobilPreview extends RegmvUploadFotoMobilState {
  final Uint8List imageBytes;
  final String fileName;
  const UploadFotoMobilPreview(this.imageBytes, this.fileName);

  @override
  List<Object?> get props => [imageBytes, fileName];
}

class UploadFotoMobilListPreview extends RegmvUploadFotoMobilState {
  final List<Uint8List> images;
  final List<String> fileNames;

  const UploadFotoMobilListPreview(this.images, this.fileNames);

  @override
  List<Object?> get props => [images, fileNames];
}


class UploadFotoMobilLoading extends RegmvUploadFotoMobilState {}

class UploadFotoMobilSuccess extends RegmvUploadFotoMobilState {}

class UploadFotoMobilFailure extends RegmvUploadFotoMobilState {
  final String error;

  const UploadFotoMobilFailure(this.error);

  @override
  List<Object?> get props => [error];
}
