part of 'regmv_upload_stnk_bloc.dart';

abstract class Regmv4UploadFotoObjectEvent extends Equatable {
  const Regmv4UploadFotoObjectEvent();

  @override
  List<Object?> get props => [];
}

class Regmv4UploadFotoObjectSelected extends Regmv4UploadFotoObjectEvent {
  final String filePath;
  final String fileName;

  const Regmv4UploadFotoObjectSelected(this.filePath, this.fileName);

  @override
  List<Object?> get props => [filePath, fileName];
}

class Regmv4UploadFotoObjectSelectedList extends Regmv4UploadFotoObjectEvent {
  final List<String> filePaths;
  final List<String> fileNames;

  const Regmv4UploadFotoObjectSelectedList(this.filePaths, this.fileNames);

  @override
  List<Object?> get props => [filePaths, fileNames];
}

class Regmv4UploadFotoObjectBatchSubmit extends Regmv4UploadFotoObjectEvent {
  final String regmv1Id;
  final List<String> filePaths;
  final List<String> names;

  const Regmv4UploadFotoObjectBatchSubmit(
      this.regmv1Id,
      this.filePaths,
      this.names,
      );

  @override
  List<Object?> get props => [regmv1Id, filePaths, names];
}

class Regmv4UploadFotoObjectResetPreview extends Regmv4UploadFotoObjectEvent {}

class Regmv4UploadFotoObjectSubmitted extends Regmv4UploadFotoObjectEvent {
  final String regmv1Id;
  final String caption;

  const Regmv4UploadFotoObjectSubmitted({
    required this.regmv1Id,
    required this.caption,
  });

  @override
  List<Object?> get props => [regmv1Id, caption];
}

class Regmv4UploadFotoObjectUploadOne extends Regmv4UploadFotoObjectEvent {
  final String localId;
  final String regmv1Id;
  final String caption;
  final String filePath;
  final String fileName;

  const Regmv4UploadFotoObjectUploadOne({
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

class Regmv4StorageUploadMany extends Regmv4UploadFotoObjectEvent {
  final String regmv1Id;
  final List<String> localIds;

  const Regmv4StorageUploadMany({
    required this.regmv1Id,
    required this.localIds,
  });

  @override
  List<Object?> get props => [regmv1Id, localIds];
}

class Regmv4StoragePickImageFromCamera extends Regmv4UploadFotoObjectEvent {}

class Regmv4StoragePickFilesFromStorage extends Regmv4UploadFotoObjectEvent {}

class Regmv4StorageRemoveAttachment extends Regmv4UploadFotoObjectEvent {
  final String localId;

  const Regmv4StorageRemoveAttachment(this.localId);

  @override
  List<Object?> get props => [localId];
}