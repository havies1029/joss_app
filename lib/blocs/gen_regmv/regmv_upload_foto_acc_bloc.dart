import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_upload_foto_acc_repository.dart';
import 'package:equatable/equatable.dart';

part 'regmv_upload_foto_acc_event.dart';
part 'regmv_upload_foto_acc_state.dart';

class RegmvUploadFotoAccBloc
    extends Bloc<RegmvUploadFotoAccEvent, RegmvUploadFotoAccState> {
  final RegmvUploadFotoAccRepository repository;
  Uint8List? _selectedImage;
  String? _fileName;

  RegmvUploadFotoAccBloc({required this.repository})
      : super(UploadFotoAccInitial()) {
    on<UploadFotoAccSelected>((event, emit) {
      _selectedImage = event.imageBytes;
      _fileName = event.fileName;
      emit(UploadFotoAccPreview(event.imageBytes, event.fileName));
    });

    on<UploadFotoAccSubmitted>((event, emit) async {
      emit(UploadFotoAccLoading());

      var success = await repository.uploadFotoAcc(
          event.regmv1Id, event.caption, _selectedImage!, _fileName!);

      if (success) {
        emit(UploadFotoAccSuccess());
      }
      else {
        emit(UploadFotoAccFailure('Upload gagal atau URL tidak ditemukan.'));
      }
    });

    on<UploadFotoAccSelectedList>((event, emit) {
      debugPrint("🟦 [UploadFotoAccSelectedList] EVENT RECEIVED");
      debugPrint("    Total Images : ${event.images.length}");
      debugPrint("    File Names   : ${event.fileNames}");

      emit(UploadFotoAccListPreview(
        List.from(event.images),
        List.from(event.fileNames),
      ));

      debugPrint("🟩 [UploadFotoAccListPreview] STATE EMITTED");
    });


    on<ResetFotoAccPreview>((event, emit) {
      debugPrint("🟦 [ResetFotoAccPreview] EVENT RECEIVED");

      emit(UploadFotoAccListPreview([], []));

      debugPrint("🟩 [UploadFotoAccListPreview] STATE EMITTED (RESET)");
    });


    on<UploadFotoAccBatchSubmit>((event, emit) async {
      debugPrint("🟦================ BATCH UPLOAD START ================");
      debugPrint("📌 regmv1Id     : ${event.regmv1Id}");
      debugPrint("📌 Total Images : ${event.images.length}");
      debugPrint("📁 File Names   : ${event.names}");

      emit(UploadFotoAccLoading());
      debugPrint("🟧 [UploadFotoAccLoading] STATE EMITTED");

      for (int i = 0; i < event.images.length; i++) {
        final img = event.images[i];
        final name = event.names[i];

        debugPrint("📤 Uploading (${i + 1}/${event.images.length}) → $name");

        _selectedImage = img;
        _fileName = name;

        final success = await repository.uploadFotoAcc(
          event.regmv1Id,
          "", // caption kosong
          img,
          name,
        );

        if (!success) {
          debugPrint("❌ Upload FAILED at index ${i + 1} → $name");
          emit(UploadFotoAccFailure("Gagal upload foto ke-${i + 1} ($name)"));
          debugPrint("🟥 [UploadFotoAccFailure] STATE EMITTED");
          debugPrint("🟥============= BATCH UPLOAD STOPPED ===============");
          return;
        }

        debugPrint("✅ Upload SUCCESS → $name");
      }

      emit(UploadFotoAccSuccess());
      debugPrint("🟩 [UploadFotoAccSuccess] STATE EMITTED");

      add(ResetFotoAccPreview());
      debugPrint("🔄 ResetFotoAccPreview EVENT DISPATCHED");

      debugPrint("🟩================ BATCH UPLOAD FINISHED ================");
    });

  }
}
