part of 'regmv_upload_foto_mobil_bloc.dart';

abstract class RegmvUploadFotoMobilEvent extends Equatable {
  const RegmvUploadFotoMobilEvent();

  @override
  List<Object?> get props => [];
}

class UploadFotoMobilSelected extends RegmvUploadFotoMobilEvent {
  final Uint8List imageBytes;
  final String fileName;
  const UploadFotoMobilSelected(this.imageBytes, this.fileName);
  @override
  List<Object?> get props => [imageBytes, fileName];
}

class UploadFotoMobilSelectedList extends RegmvUploadFotoMobilEvent {
  final List<Uint8List> images;
  final List<String> fileNames;

  const UploadFotoMobilSelectedList(this.images, this.fileNames);

  @override
  List<Object?> get props => [images, fileNames];
}

class UploadFotoMobilSubmitted extends RegmvUploadFotoMobilEvent {
  final String regmv1Id;
  final String caption;

  const UploadFotoMobilSubmitted({required this.regmv1Id, required this.caption});
  
  @override
  List<Object?> get props => [regmv1Id, caption];
}

class UploadFotoMobilBatchSubmit extends RegmvUploadFotoMobilEvent {
  final String regmv1Id;
  final List<Uint8List> images;
  final List<String> names;

  const UploadFotoMobilBatchSubmit({
    required this.regmv1Id,
    required this.images,
    required this.names,
  });

  @override
  List<Object?> get props => [regmv1Id, images, names];
}

class ResetFotoMobilPreview extends RegmvUploadFotoMobilEvent {}


class CekIsFotoMobilUploaded extends RegmvUploadFotoMobilEvent {
  final String mrekanId;
  const CekIsFotoMobilUploaded(this.mrekanId);

  @override
  List<Object?> get props => [mrekanId];
}