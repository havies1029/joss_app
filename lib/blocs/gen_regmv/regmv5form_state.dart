part of 'regmv5form_bloc.dart';

class Regmv5FormState extends Equatable {

	final bool isSaving;
	final bool isSaved;
	final bool isUploading;
	final bool isUploaded;
	final bool isDownloading;
	final bool isDownloaded;
	final bool isDeleting;
	final bool isDeleted;
	final Uint8List? fotoBytes;
	final bool isPendingUpload;
	final String fotoPath;
	final String imageSource;
	final String errorMsg;
	final String fileName;
	final bool hasFailure;
	const Regmv5FormState(
			{this.isSaving = false,
				this.isSaved = false,
				this.isUploading = false,
				this.isUploaded = false,
				this.isDownloading = false,
				this.isDownloaded = false,
				this.isDeleting = false,
				this.isDeleted = false,
				this.hasFailure = false,
				this.isPendingUpload = false,
				this.fotoBytes,
				this.fotoPath = "",
				this.imageSource = "",
				this.errorMsg = "",
				this.fileName = "",
			});

	const Regmv5FormState.reset()
			: this(fotoPath: "", fotoBytes: null, fileName: "", imageSource: "");


	Regmv5FormState copyWith({
		bool? isSaving,
		bool? isSaved,
		bool? isUploading,
		bool? isUploaded,
		bool? isDownloading,
		bool? isDownloaded,
		bool? isDeleting,
		bool? isDeleted,
		bool? hasFailure,
		bool? isPendingUpload,
		Uint8List? fotoBytes,
		String? fotoPath,
		String? imageSource,
		String? errorMsg,
		String? fileName,
	}){
		return Regmv5FormState(
				isSaving: isSaving ?? this.isSaving,
				isSaved: isSaved ?? this.isSaved,
				isUploading: isUploading ?? this.isUploading,
				isUploaded: isUploaded ?? this.isUploaded,
				isDownloading: isDownloading ?? this.isDownloading,
				isDownloaded: isDownloaded ?? this.isDownloaded,
				isDeleting: isDeleting ?? this.isDeleting,
				isDeleted: isDeleted ?? this.isDeleted,
				hasFailure: hasFailure ?? this.hasFailure,
				isPendingUpload: isPendingUpload ?? this.isPendingUpload,
				fotoBytes: fotoBytes ?? this.fotoBytes,
				fotoPath: fotoPath ?? this.fotoPath,
				imageSource: imageSource ?? this.imageSource,
				errorMsg: errorMsg ?? this.errorMsg,
				fileName: fileName ?? this.fileName
		);
	}

	@override
	List<Object?> get props => [
		isSaving,
		isSaved,
		isUploading,
		isUploaded,
		isDownloading,
		isDownloaded,
		isDeleting,
		isDeleted,
		hasFailure,
		isPendingUpload,
		fotoBytes,
		fotoPath,
		imageSource,
		errorMsg,
		fileName,
	];
}
