part of 'regmv_upload_stnk_bloc.dart';

abstract class RegmvUploadStnkEvent extends Equatable {
  const RegmvUploadStnkEvent();

  @override
  List<Object?> get props => [];
}

class UploadStnkSelected extends RegmvUploadStnkEvent {
  final Uint8List imageBytes;
  final String fileName;
  const UploadStnkSelected(this.imageBytes, this.fileName);

  @override
  List<Object?> get props => [imageBytes, fileName];
}

class UploadStnkSelectedList extends RegmvUploadStnkEvent {
  final List<Uint8List> images;
  final List<String> fileNames;

  const UploadStnkSelectedList(this.images, this.fileNames);

  @override
  List<Object?> get props => [images, fileNames];
}

class UploadStnkSubmitted extends RegmvUploadStnkEvent {
  final String regmv1Id;
  final String caption;

  const UploadStnkSubmitted({required this.regmv1Id, required this.caption});
  
  @override
  List<Object?> get props => [regmv1Id, caption];
}

class UploadStnkBatchSubmit extends RegmvUploadStnkEvent {
  final String regmv1Id;
  final List<Uint8List> images;
  final List<String> names;

  const UploadStnkBatchSubmit({
    required this.regmv1Id,
    required this.images,
    required this.names,
  });

  @override
  List<Object?> get props => [regmv1Id, images, names];
}

class ResetStnkPreview extends RegmvUploadStnkEvent {}


class CekIsStnkUploaded extends RegmvUploadStnkEvent {
  final String mrekanId;
  const CekIsStnkUploaded(this.mrekanId);

  @override
  List<Object?> get props => [mrekanId];
}