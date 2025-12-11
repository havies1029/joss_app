part of 'regmv_upload_foto_acc_bloc.dart';

abstract class RegmvUploadFotoAccEvent extends Equatable {
  const RegmvUploadFotoAccEvent();

  @override
  List<Object?> get props => [];
}

class UploadFotoAccSelected extends RegmvUploadFotoAccEvent {
  final Uint8List imageBytes;
  final String fileName;
  const UploadFotoAccSelected(this.imageBytes, this.fileName);
  @override
  List<Object?> get props => [imageBytes, fileName];
}

class UploadFotoAccSelectedList extends RegmvUploadFotoAccEvent {
  final List<Uint8List> images;
  final List<String> fileNames;

  const UploadFotoAccSelectedList(this.images, this.fileNames);

  @override
  List<Object?> get props => [images, fileNames];
}


class UploadFotoAccSubmitted extends RegmvUploadFotoAccEvent {
  final String regmv1Id;
  final String caption;

  const UploadFotoAccSubmitted({required this.regmv1Id, required this.caption});
  
  @override
  List<Object?> get props => [regmv1Id, caption];
}

class UploadFotoAccBatchSubmit extends RegmvUploadFotoAccEvent {
  final String regmv1Id;
  final List<Uint8List> images;
  final List<String> names;

  const UploadFotoAccBatchSubmit({
    required this.regmv1Id,
    required this.images,
    required this.names,
  });

  @override
  List<Object?> get props => [regmv1Id, images, names];
}

class ResetFotoAccPreview extends RegmvUploadFotoAccEvent {}

class CekIsFotoAccUploaded extends RegmvUploadFotoAccEvent {
  final String mrekanId;
  const CekIsFotoAccUploaded(this.mrekanId);

  @override
  List<Object?> get props => [mrekanId];
}