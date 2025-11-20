import 'dart:convert';
import 'dart:typed_data';

import 'package:joss_app/models/image/downloadfileinfo64.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv4form_repository.dart';

import '../../helper/image_helper.dart';

part 'regmv4form_event.dart';
part 'regmv4form_state.dart';

class Regmv4FormBloc extends Bloc<Regmv4FormEvents, Regmv4FormState> {
	final Regmv4FormRepository repository;
	Regmv4FormBloc({required this.repository}) : super(const Regmv4FormState()) {
		on<UploadFileStnkEvent>(onUploadFile);
		on<UploadBinaryStnkEvent>(onUploadFileBytes);
		on<DownloadFotoStnkEvent>(onDownloadFile);
		on<Regmv4FormHapusEvent>(onHapusRegmv4Form);
		on<HapusFotoStnkStateEvent>(onHapusFotoState);
		on<ResetStateFotoStnkEvent>(onResetState);
		on<Save2StateFileStnkEvent>(onSaveFotoLocalPath2State);
		on<Save2StateBinaryStnkEvent>(onSaveFotoBinary2State);
		on<SetErrorFotoStnkEvent>(onSetError);
	}

	Future<void> onResetState(
			ResetStateFotoStnkEvent event, Emitter<Regmv4FormState> emit) async {
		emit(state.copyWith(
				isUploaded: false,
				isUploading: false,
				isDownloaded: false,
				isDownloading: false,
				isDeleted: false,
				isDeleting: false,
				hasFailure: false,
				fotoPath: "",
				isPendingUpload: false,
				imageSource: ""));

		emit(Regmv4FormState.reset());
	}

	Future<void> onSetError(
			SetErrorFotoStnkEvent event, Emitter<Regmv4FormState> emit) async {
		debugPrint("onSetError");
		emit(state.copyWith(hasFailure: false));
		emit(state.copyWith(hasFailure: true));
	}

	Future<void> onSaveFotoLocalPath2State(
			Save2StateFileStnkEvent event,
			Emitter<Regmv4FormState> emit) async {
		emit(state.copyWith(
				isUploading: true, isUploaded: false, isPendingUpload: false));

		emit(state.copyWith(
				isUploading: false,
				isUploaded: true,
				fotoPath: event.filePath,
				isPendingUpload: true,
				imageSource: event.imageSource));
	}

	Future<void> onSaveFotoBinary2State(Save2StateBinaryStnkEvent event,
			Emitter<Regmv4FormState> emit) async {
		emit(state.copyWith(
				isUploading: true, isUploaded: false, isPendingUpload: false));

		emit(state.copyWith(
				isUploading: false,
				isUploaded: true,
				fotoBytes: event.fotoBytes,
				isPendingUpload: true,
				imageSource: event.imageSource,
				fileName: event.fileName));
	}

	Future<void> onUploadFile(
			UploadFileStnkEvent event, Emitter<Regmv4FormState> emit) async {
		debugPrint("[Regmv4FormBloc] onUploadFile, regmv1Id = ${event.regmv1Id}");
		emit(state.copyWith(
			isUploading: true,
			isUploaded: false,
			hasFailure: false,
		));

		// 🔥 kirim regmv1Id ke repository
		ReturnDataAPI returnData =
		await repository.uploadFileFotoSTNK(event.regmv1Id, event.filePath);

		debugPrint("event.filePath : ${event.filePath}");

		emit(state.copyWith(
			isUploading: false,
			isUploaded: true,
			fotoPath: event.filePath,
			isPendingUpload: false,
			hasFailure: !returnData.success,
			imageSource: event.imageSource,
		));
	}

	Future<void> onUploadFileBytes(
			UploadBinaryStnkEvent event, Emitter<Regmv4FormState> emit) async {
		debugPrint("[Regmv4FormBloc] onUploadFileBytes, regmv1Id = ${event.regmv1Id}");

		emit(state.copyWith(
			isUploading: true,
			isUploaded: false,
			hasFailure: false,
		));

		// 🔥 kirim regmv1Id ke repository
		ReturnDataAPI result = await repository.uploadBinaryFotoSTNK(
			event.regmv1Id,
			event.fileName,
			event.bytes,
		);

		emit(state.copyWith(
			isUploading: false,
			isUploaded: true,
			hasFailure: !result.success,
			isPendingUpload: false,
			imageSource: event.imageSource,

			fotoBytes: event.bytes,
			fileName: event.fileName,
			fotoPath: "",
		));
	}

	Future<void> onDownloadFile(
			DownloadFotoStnkEvent event, Emitter<Regmv4FormState> emit) async {
		debugPrint("onDownloadFile #10");

		emit(state.copyWith(isDownloading: true, isDownloaded: false));

		DownloadFileInfo64Model? fileInfo =
		await repository.downloadFotoStnkAPI(event.regmv4Id);

		//debugPrint("fileInfo : ${fileInfo.toString()}");

		debugPrint("onDownloadFile #20");

		if (fileInfo != null) {
			//debugPrint("fileInfo.datafile64! : ${fileInfo.datafile64}");

			ImageHelper helper = ImageHelper();
			Uint8List bytes = base64Decode(fileInfo.datafile64!);

			debugPrint("onDownloadFile #30");

			String filePath = await helper.convertBytes2LocalImage(
					fileName: fileInfo.namafile, bytes: bytes);

			debugPrint("onDownloadFile #40");

			debugPrint("event.filePath : $filePath");

			emit(state.copyWith(
					isDownloading: false,
					isDownloaded: true,
					//fileFoto: fileFoto,
					fotoPath: filePath));
		} else {
			emit(state.copyWith(
					isDownloading: false, isDownloaded: false, fotoPath: ""));
		}
	}

	Future<void> onHapusRegmv4Form(
			Regmv4FormHapusEvent event, Emitter<Regmv4FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regmv4FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusFotoState(HapusFotoStnkStateEvent event,
			Emitter<Regmv4FormState> emit) async {
		emit(state.copyWith(isDeleting: true, isDeleted: false));

		emit(state.copyWith(isDeleting: false, isDeleted: true, fotoPath: ""));
	}

}