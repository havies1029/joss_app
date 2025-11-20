part of 'regmv5form_bloc.dart';

abstract class Regmv5FormEvents extends Equatable {
	const Regmv5FormEvents();

	@override
	List<Object> get props => [];
}

class Regmv5FormHapusEvent extends Regmv5FormEvents {
	final String recordId;
	const Regmv5FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}


class UploadFileFotoEvent extends Regmv5FormEvents {
	final String regmv1Id;   // ✅ parent
	final String filePath;
	final String imageSource;

	const UploadFileFotoEvent({
		required this.regmv1Id,
		required this.filePath,
		required this.imageSource,
	});

	@override
	List<Object> get props => [regmv1Id, filePath, imageSource];
}

class UploadBinaryFotoEvent extends Regmv5FormEvents {
	final String regmv1Id;   // ✅ parent
	final String fileName;
	final Uint8List bytes;
	final String imageSource;

	const UploadBinaryFotoEvent({
		required this.regmv1Id,
		required this.fileName,
		required this.bytes,
		required this.imageSource,
	});

	@override
	List<Object> get props => [regmv1Id, fileName, bytes, imageSource];
}

class Save2StateFileFotoEvent extends Regmv5FormEvents {
	final String filePath;
	final String imageSource;
	const Save2StateFileFotoEvent(
			{required this.filePath, required this.imageSource});

	@override
	List<Object> get props => [filePath, imageSource];
}

class Save2StateBinaryFotoEvent extends Regmv5FormEvents {
	final Uint8List fotoBytes;
	final String imageSource;
	final String fileName;
	const Save2StateBinaryFotoEvent(
			{required this.fotoBytes, required this.imageSource, required this.fileName});

	@override
	List<Object> get props => [fotoBytes, imageSource, fileName];
}

class DownloadFotoEvent extends Regmv5FormEvents {
	final String regmv5Id;
	const DownloadFotoEvent({required this.regmv5Id});

	@override
	List<Object> get props => [regmv5Id];
}

class HapusFotoStateEvent extends Regmv5FormEvents {}

class ResetStateFotoEvent extends Regmv5FormEvents {}

class SetErrorFotoEvent extends Regmv5FormEvents {
	final String errorMsg;
	const SetErrorFotoEvent({required this.errorMsg});

	@override
	List<Object> get props => [errorMsg];
}


