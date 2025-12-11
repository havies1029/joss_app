part of 'regpar_upload_foto_object_bloc.dart';

abstract class RegparUploadFotoObjectEvent extends Equatable {
  const RegparUploadFotoObjectEvent();

  @override
  List<Object?> get props => [];
}

class UploadFotoObjectSelected extends RegparUploadFotoObjectEvent {
  final Uint8List imageBytes;
  final String fileName;
  const UploadFotoObjectSelected(this.imageBytes, this.fileName);
  @override
  List<Object?> get props => [imageBytes, fileName];
}

class UploadFotoObjectSelectedList extends RegparUploadFotoObjectEvent {
  final List<Uint8List> images;
  final List<String> fileNames;

  const UploadFotoObjectSelectedList(this.images, this.fileNames);

  @override
  List<Object?> get props => [images, fileNames];
}

class UploadFotoObjectBatchSubmit extends RegparUploadFotoObjectEvent {
  final String regpar1Id;
  final List<Uint8List> images;
  final List<String> names;

  const UploadFotoObjectBatchSubmit({
    required this.regpar1Id,
    required this.images,
    required this.names,
  });

  @override
  List<Object?> get props => [regpar1Id, images, names];
}

class ResetFotoObjectPreview extends RegparUploadFotoObjectEvent {}


class UploadFotoObjectSubmitted extends RegparUploadFotoObjectEvent {
  final String regpar1Id;
  final String caption;

  const UploadFotoObjectSubmitted({required this.regpar1Id, required this.caption});
  
  @override
  List<Object?> get props => [regpar1Id, caption];
}

