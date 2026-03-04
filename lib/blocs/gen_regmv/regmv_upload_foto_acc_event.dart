part of 'regmv_upload_foto_acc_bloc.dart';

abstract class Regmv7UploadFotoObjectEvent extends Equatable {
  const Regmv7UploadFotoObjectEvent();

  @override
  List<Object?> get props => [];
}

class Regmv7UploadFotoObjectSelected extends Regmv7UploadFotoObjectEvent {
  final String filePath;
  final String fileName;

  const Regmv7UploadFotoObjectSelected(this.filePath, this.fileName);

  @override
  List<Object?> get props => [filePath, fileName];
}

class Regmv7UploadFotoObjectSelectedList extends Regmv7UploadFotoObjectEvent {
  final List<String> filePaths;
  final List<String> fileNames;

  const Regmv7UploadFotoObjectSelectedList(this.filePaths, this.fileNames);

  @override
  List<Object?> get props => [filePaths, fileNames];
}

class Regmv7UploadFotoObjectBatchSubmit extends Regmv7UploadFotoObjectEvent {
  final String regmv1Id;
  final List<String> filePaths;
  final List<String> names;

  const Regmv7UploadFotoObjectBatchSubmit(
      this.regmv1Id,
      this.filePaths,
      this.names,
      );

  @override
  List<Object?> get props => [regmv1Id, filePaths, names];
}

class Regmv7UploadFotoObjectResetPreview extends Regmv7UploadFotoObjectEvent {}

class Regmv7UploadFotoObjectSubmitted extends Regmv7UploadFotoObjectEvent {
  final String regmv1Id;
  final String caption;

  const Regmv7UploadFotoObjectSubmitted({
    required this.regmv1Id,
    required this.caption,
  });

  @override
  List<Object?> get props => [regmv1Id, caption];
}

class Regmv7UploadFotoObjectUploadOne extends Regmv7UploadFotoObjectEvent {
  final String localId;
  final String regmv1Id;
  final String caption;
  final String filePath;
  final String fileName;

  const Regmv7UploadFotoObjectUploadOne({
    required this.localId,
    required this.regmv1Id,
    required this.caption,
    required this.filePath,
    required this.fileName,
  });

  @override
  List<Object?> get props => [
    localId,
    regmv1Id,
    caption,
    filePath,
    fileName,
  ];
}

class Regmv7StorageUploadMany extends Regmv7UploadFotoObjectEvent {
  final String regmv1Id;
  final List<String> localIds;

  const Regmv7StorageUploadMany({
    required this.regmv1Id,
    required this.localIds,
  });

  @override
  List<Object?> get props => [regmv1Id, localIds];
}

class Regmv7StoragePickImageFromCamera extends Regmv7UploadFotoObjectEvent {}

class Regmv7StoragePickFilesFromStorage extends Regmv7UploadFotoObjectEvent {}

class Regmv7StorageRemoveAttachment extends Regmv7UploadFotoObjectEvent {
  final String localId;

  const Regmv7StorageRemoveAttachment(this.localId);

  @override
  List<Object?> get props => [localId];
}