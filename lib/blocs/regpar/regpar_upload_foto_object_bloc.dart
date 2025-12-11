import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:joss_app/repositories/regpar/regpar_upload_fotoobject_repository.dart';
import 'package:equatable/equatable.dart';

part 'regpar_upload_foto_object_event.dart';
part 'regpar_upload_foto_object_state.dart';

class RegparUploadFotoObjectBloc
    extends Bloc<RegparUploadFotoObjectEvent, RegparUploadFotoObjectState> {
  final RegparUploadFotoObjectRepository repository;
  Uint8List? _selectedImage;
  String? _fileName;

  RegparUploadFotoObjectBloc({required this.repository})
      : super(UploadFotoObjectInitial()) {
    on<UploadFotoObjectSelected>((event, emit) {
      _selectedImage = event.imageBytes;
      _fileName = event.fileName;
      emit(UploadFotoObjectPreview(event.imageBytes, event.fileName));
    });

    on<UploadFotoObjectSelectedList>((event, emit) {
      emit(UploadFotoObjectListPreview(
        List.from(event.images),
        List.from(event.fileNames),
      ));

    });

    on<ResetFotoObjectPreview>((event, emit) {
      emit(UploadFotoObjectListPreview([], []));
    });

    on<UploadFotoObjectBatchSubmit>((event, emit) async {
      emit(UploadFotoObjectLoading());
      for (int i = 0; i < event.images.length; i++) {
        final img = event.images[i];
        final name = event.names[i];
        _selectedImage = img;
        _fileName = name;
        final success = await repository.uploadFotoObject(
          event.regpar1Id,
          "", // caption kosong
          img,
          name,
        );

        if (!success) {
          emit(UploadFotoObjectFailure("Gagal upload foto ke-${i + 1} ($name)"));
          return;
        }
      }
      emit(UploadFotoObjectSuccess());
      add(ResetFotoObjectPreview());
    });

    on<UploadFotoObjectSubmitted>((event, emit) async {
      emit(UploadFotoObjectLoading());

      var success = await repository.uploadFotoObject(event.regpar1Id, event.caption, _selectedImage!, _fileName!);

      if (success){
        emit(UploadFotoObjectSuccess());
      }
      else {
        emit(UploadFotoObjectFailure('Upload gagal atau URL tidak ditemukan.'));
      }

    });
  }
}
