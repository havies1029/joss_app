import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_upload_foto_mobil_repository.dart';
import 'package:equatable/equatable.dart';

part 'regmv_upload_foto_mobil_event.dart';
part 'regmv_upload_foto_mobil_state.dart';

class RegmvUploadFotoMobilBloc
    extends Bloc<RegmvUploadFotoMobilEvent, RegmvUploadFotoMobilState> {
  final RegmvUploadFotoMobilRepository repository;
  Uint8List? _selectedImage;
  String? _fileName;

  RegmvUploadFotoMobilBloc({required this.repository})
      : super(UploadFotoMobilInitial()) {
    on<UploadFotoMobilSelected>((event, emit) {
      _selectedImage = event.imageBytes;
      _fileName = event.fileName;
      emit(UploadFotoMobilPreview(event.imageBytes, event.fileName));
    });

    on<UploadFotoMobilSubmitted>((event, emit) async {
      emit(UploadFotoMobilLoading());

      var success = await repository.uploadFotoMobil(event.regmv1Id, event.caption, _selectedImage!, _fileName!);

      if (success){
        emit(UploadFotoMobilSuccess());
      }
      else {
        emit(UploadFotoMobilFailure('Upload gagal atau URL tidak ditemukan.'));
      }

    });
  }
}
