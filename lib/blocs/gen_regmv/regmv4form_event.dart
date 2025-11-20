part of 'regmv4form_bloc.dart';

abstract class Regmv4FormEvents extends Equatable {
	const Regmv4FormEvents();

	@override
	List<Object> get props => [];
}


class Regmv4FormHapusEvent extends Regmv4FormEvents {
	final String recordId;
	const Regmv4FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class UploadFileStnkEvent extends Regmv4FormEvents {
	final String regmv1Id;
	final String filePath;
	final String imageSource;

	const UploadFileStnkEvent({
		required this.regmv1Id,
		required this.filePath,
		required this.imageSource,
	});

	@override
	List<Object> get props => [regmv1Id, filePath, imageSource];
}

class UploadBinaryStnkEvent extends Regmv4FormEvents {
	final String regmv1Id;
	final String fileName;
	final Uint8List bytes;
	final String imageSource;

	const UploadBinaryStnkEvent({
		required this.regmv1Id,
		required this.fileName,
		required this.bytes,
		required this.imageSource,
	});

	@override
	List<Object> get props => [regmv1Id, fileName, bytes, imageSource];
}

class Save2StateFileStnkEvent extends Regmv4FormEvents {
	final String filePath;
	final String imageSource;
	const Save2StateFileStnkEvent(
			{required this.filePath, required this.imageSource});

	@override
	List<Object> get props => [filePath, imageSource];
}

class Save2StateBinaryStnkEvent extends Regmv4FormEvents {
	final Uint8List fotoBytes;
	final String imageSource;
	final String fileName;
	const Save2StateBinaryStnkEvent(
			{required this.fotoBytes, required this.imageSource, required this.fileName});

	@override
	List<Object> get props => [fotoBytes, imageSource, fileName];
}

class DownloadFotoStnkEvent extends Regmv4FormEvents {
	final String regmv4Id;
	const DownloadFotoStnkEvent({required this.regmv4Id});

	@override
	List<Object> get props => [regmv4Id];
}

class HapusFotoStnkStateEvent extends Regmv4FormEvents {}

class ResetStateFotoStnkEvent extends Regmv4FormEvents {}

class SetErrorFotoStnkEvent extends Regmv4FormEvents {
	final String errorMsg;
	const SetErrorFotoStnkEvent({required this.errorMsg});

	@override
	List<Object> get props => [errorMsg];
}
