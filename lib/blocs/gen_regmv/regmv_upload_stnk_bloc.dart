import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_upload_stnk_repository.dart';
import 'package:equatable/equatable.dart';

part 'regmv_upload_stnk_event.dart';
part 'regmv_upload_stnk_state.dart';

class RegmvUploadStnkBloc
    extends Bloc<RegmvUploadStnkEvent, RegmvUploadStnkState> {
  final RegmvUploadStnkRepository repository;
  Uint8List? _selectedImage;
  String? _fileName;

  RegmvUploadStnkBloc({required this.repository})
      : super(UploadStnkInitial()) {

    on<UploadStnkSelected>((event, emit) {
      _selectedImage = event.imageBytes;
      _fileName = event.fileName;
      emit(UploadStnkPreview(event.imageBytes, event.fileName));

    });

    on<UploadStnkSelectedList>((event, emit) {
      emit(UploadStnkListPreview(
        List.from(event.images),
        List.from(event.fileNames),
      ));

    });

    on<ResetStnkPreview>((event, emit) {
      emit(UploadStnkListPreview([], []));
    });

    on<UploadStnkBatchSubmit>((event, emit) async {
      emit(UploadStnkLoading());
      for (int i = 0; i < event.images.length; i++) {
        final img = event.images[i];
        final name = event.names[i];
        _selectedImage = img;
        _fileName = name;
        final success = await repository.uploadStnk(
          event.regmv1Id,
          "", // caption kosong
          img,
          name,
        );

        if (!success) {
          emit(UploadStnkFailure("Gagal upload foto ke-${i + 1} ($name)"));
          return;
        }
      }
      emit(UploadStnkSuccess());
      add(ResetStnkPreview());
    });

  }



}
