import 'dart:convert';
import 'dart:typed_data';

import 'package:joss_app/models/image/downloadfileinfo64.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv5form_repository.dart';

import '../../helper/image_helper.dart';

part 'regmv5form_event.dart';
part 'regmv5form_state.dart';

class Regmv5FormBloc extends Bloc<Regmv5FormEvents, Regmv5FormState> {
	final Regmv5FormRepository repository;
	Regmv5FormBloc({required this.repository}) : super(const Regmv5FormState()) {
		on<UploadFileFotoEvent>(onUploadFile);
		on<UploadBinaryFotoEvent>(onUploadFileBytes);
		on<DownloadFotoEvent>(onDownloadFile);
		on<Regmv5FormHapusEvent>(onHapusRegmv5Form);
		on<HapusFotoStateEvent>(onHapusFotoState);
		on<ResetStateFotoEvent>(onResetState);
		on<Save2StateFileFotoEvent>(onSaveFotoLocalPath2State);
		on<Save2StateBinaryFotoEvent>(onSaveFotoBinary2State);
		on<SetErrorFotoEvent>(onSetError);
	}

	Future<void> onResetState(
			ResetStateFotoEvent event,
			Emitter<Regmv5FormState> emit,
			) async {
		emit(const Regmv5FormState.reset());
	}

	Future<void> onSetError(
			SetErrorFotoEvent event,
			Emitter<Regmv5FormState> emit,
			) async {
		emit(state.copyWith(
			hasFailure: true,
			errorMsg: event.errorMsg,
			isUploading: false,
			isUploaded: true,
			isPendingUpload: false,
		));
	}

	Future<void> onSaveFotoBinary2State(
			Save2StateBinaryFotoEvent event,
			Emitter<Regmv5FormState> emit,
			) async {

		// penyimpanan lokal di state (preview)
		emit(state.copyWith(
			fotoBytes: event.fotoBytes,
			fileName: event.fileName,
			fotoPath: "",
			imageSource: event.imageSource,
			isPendingUpload: true,
			isUploaded: false,     // ⛔ jangan tandai upload
			hasFailure: false,
		));
	}

	Future<void> onUploadFile(
			UploadFileFotoEvent event,
			Emitter<Regmv5FormState> emit,
			) async {

		emit(state.copyWith(isUploading: true, hasFailure: false));

		final result = await repository.uploadFileFotoMobil(
			event.regmv1Id,
			event.filePath,
		);

		emit(state.copyWith(
			isUploading: false,
			isUploaded: true,
			hasFailure: !result.success,
			isPendingUpload: false,
			fotoPath: event.filePath,
			fotoBytes: null,
			imageSource: event.imageSource,
		));
	}

	Future<void> onUploadFileBytes(
			UploadBinaryFotoEvent event,
			Emitter<Regmv5FormState> emit,
			) async {

		emit(state.copyWith(
			isUploading: true,
			hasFailure: false,
		));

		final result = await repository.uploadBinaryFotoMobil(
			event.regmv1Id,
			event.fileName,
			event.bytes,
		);

		emit(state.copyWith(
			isUploading: false,
			isUploaded: true,         // ⬅ baru diset DI SINI
			hasFailure: !result.success,
			isPendingUpload: false,   // sudah tidak pending lagi
			fotoBytes: event.bytes,   // tetap tampilkan preview
			fotoPath: "",
			fileName: event.fileName,
			imageSource: event.imageSource,
		));
	}

	Future<void> onDownloadFile(
			DownloadFotoEvent event, Emitter<Regmv5FormState> emit) async {
		debugPrint("onDownloadFile #10");

		emit(state.copyWith(isDownloading: true, isDownloaded: false));

		DownloadFileInfo64Model? fileInfo =
		await repository.downloadFotoMobilAPI(event.regmv5Id);

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

	Future<void> onSaveFotoLocalPath2State(
			Save2StateFileFotoEvent event,
			Emitter<Regmv5FormState> emit) async {
		emit(state.copyWith(
				isUploading: true, isUploaded: false, isPendingUpload: false));

		emit(state.copyWith(
				isUploading: false,
				isUploaded: true,
				fotoPath: event.filePath,
				isPendingUpload: true,
				imageSource: event.imageSource));
	}

	Future<void> onHapusRegmv5Form(
			Regmv5FormHapusEvent event, Emitter<Regmv5FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regmv5FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusFotoState(
			HapusFotoStateEvent event,
			Emitter<Regmv5FormState> emit,
			) async {
		emit(state.copyWith(
			isDeleted: true,
			fotoPath: "",
			fotoBytes: null,
			fileName: "",
			imageSource: "",
			isPendingUpload: false,
		));
	}
}