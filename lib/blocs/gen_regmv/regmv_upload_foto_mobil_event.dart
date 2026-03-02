part of 'regmv_upload_foto_mobil_bloc.dart';

abstract class Regmv5UploadFotoObjectEvent extends Equatable {
  const Regmv5UploadFotoObjectEvent();

  @override
  List<Object?> get props => [];
}

class Regmv5UploadFotoObjectSelected extends Regmv5UploadFotoObjectEvent {
  final String filePath;
  final String fileName;

  const Regmv5UploadFotoObjectSelected(this.filePath, this.fileName);

  @override
  List<Object?> get props => [filePath, fileName];
}

class Regmv5UploadFotoObjectSelectedList extends Regmv5UploadFotoObjectEvent {
  final List<String> filePaths;
  final List<String> fileNames;

  const Regmv5UploadFotoObjectSelectedList(this.filePaths, this.fileNames);

  @override
  List<Object?> get props => [filePaths, fileNames];
}

class Regmv5UploadFotoObjectBatchSubmit extends Regmv5UploadFotoObjectEvent {
  final String regmv1Id;
  final List<String> filePaths;
  final List<String> names;

  const Regmv5UploadFotoObjectBatchSubmit(
      this.regmv1Id,
      this.filePaths,
      this.names,
      );

  @override
  List<Object?> get props => [regmv1Id, filePaths, names];
}

class Regmv5UploadFotoObjectResetPreview extends Regmv5UploadFotoObjectEvent {}

class Regmv5UploadFotoObjectSubmitted extends Regmv5UploadFotoObjectEvent {
  final String regmv1Id;
  final String caption;

  const Regmv5UploadFotoObjectSubmitted({
    required this.regmv1Id,
    required this.caption,
  });

  @override
  List<Object?> get props => [regmv1Id, caption];
}

class Regmv5UploadFotoObjectUploadOne extends Regmv5UploadFotoObjectEvent {
  final String localId;
  final String regmv1Id;
  final String caption;
  final String filePath;
  final String fileName;

  const Regmv5UploadFotoObjectUploadOne({
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

class Regmv5StorageUploadMany extends Regmv5UploadFotoObjectEvent {
  final String regmv1Id;
  final List<String> localIds;

  const Regmv5StorageUploadMany({
    required this.regmv1Id,
    required this.localIds,
  });

  @override
  List<Object?> get props => [regmv1Id, localIds];
}

class Regmv5StoragePickImageFromCamera extends Regmv5UploadFotoObjectEvent {}

class Regmv5StoragePickFilesFromStorage extends Regmv5UploadFotoObjectEvent {}

class Regmv5StorageRemoveAttachment extends Regmv5UploadFotoObjectEvent {
  final String localId;

  const Regmv5StorageRemoveAttachment(this.localId);

  @override
  List<Object?> get props => [localId];
}