part of 'regpar_upload_foto_object_bloc.dart';

abstract class RegparUploadFotoObjectEvent extends Equatable {
  const RegparUploadFotoObjectEvent();

  @override
  List<Object?> get props => [];
}

class RegparUploadFotoObjectSelected extends RegparUploadFotoObjectEvent {
  final String filePath;
  final String fileName;

  const RegparUploadFotoObjectSelected(this.filePath, this.fileName);

  @override
  List<Object?> get props => [filePath, fileName];
}

class RegparUploadFotoObjectSelectedList extends RegparUploadFotoObjectEvent {
  final List<String> filePaths;
  final List<String> fileNames;

  const RegparUploadFotoObjectSelectedList(this.filePaths, this.fileNames);

  @override
  List<Object?> get props => [filePaths, fileNames];
}

class RegparUploadFotoObjectBatchSubmit extends RegparUploadFotoObjectEvent {
  final String regpar1Id;
  final List<String> filePaths;
  final List<String> names;

  const RegparUploadFotoObjectBatchSubmit(
      this.regpar1Id,
      this.filePaths,
      this.names,
      );

  @override
  List<Object?> get props => [regpar1Id, filePaths, names];
}

class RegparUploadFotoObjectResetPreview extends RegparUploadFotoObjectEvent {}

class RegparUploadFotoObjectSubmitted extends RegparUploadFotoObjectEvent {
  final String regpar1Id;
  final String caption;

  const RegparUploadFotoObjectSubmitted({
    required this.regpar1Id,
    required this.caption,
  });

  @override
  List<Object?> get props => [regpar1Id, caption];
}

class RegparUploadFotoObjectUploadOne extends RegparUploadFotoObjectEvent {
  final String localId;
  final String regpar1Id;
  final String caption;
  final String filePath;
  final String fileName;

  const RegparUploadFotoObjectUploadOne({
    required this.localId,
    required this.regpar1Id,
    required this.caption,
    required this.filePath,
    required this.fileName,
  });

  @override
  List<Object?> get props => [
    localId,
    regpar1Id,
    caption,
    filePath,
    fileName,
  ];
}

class RegparStorageUploadMany extends RegparUploadFotoObjectEvent {
  final String regpar1Id;
  final List<String> localIds;

  const RegparStorageUploadMany({
    required this.regpar1Id,
    required this.localIds,
  });
}

class RegparStoragePickImageFromCamera extends RegparUploadFotoObjectEvent {}

class RegparStoragePickFilesFromStorage extends RegparUploadFotoObjectEvent {}

class RegparStorageRemoveAttachment extends RegparUploadFotoObjectEvent {
  final String localId;

  const RegparStorageRemoveAttachment(this.localId);

  @override
  List<Object?> get props => [localId];
}