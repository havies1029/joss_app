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

class UploadStnkSubmitted extends RegmvUploadStnkEvent {
  final String regmv1Id;
  final String caption;

  const UploadStnkSubmitted({required this.regmv1Id, required this.caption});
  
  @override
  List<Object?> get props => [regmv1Id, caption];
}

class CekIsStnkUploaded extends RegmvUploadStnkEvent {
  final String mrekanId;
  const CekIsStnkUploaded(this.mrekanId);

  @override
  List<Object?> get props => [mrekanId];
}