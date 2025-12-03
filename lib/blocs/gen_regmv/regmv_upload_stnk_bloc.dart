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

    on<UploadStnkSubmitted>((event, emit) async {
      emit(UploadStnkLoading());

      var success = await repository.uploadStnk(event.regmv1Id, event.caption, _selectedImage!, _fileName!);

      if (success){
        emit(UploadStnkSuccess());
      }
      else {
        emit(UploadStnkFailure('Upload gagal atau URL tidak ditemukan.'));
      }

    });
  }
}
