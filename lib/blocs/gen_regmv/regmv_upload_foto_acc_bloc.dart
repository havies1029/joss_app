import 'dart:typed_data';
import 'package:bloc/bloc.dart';
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

      var success = await repository.uploadFotoAcc(event.regmv1Id, event.caption, _selectedImage!, _fileName!);

      if (success){
        emit(UploadFotoAccSuccess());
      }
      else {
        emit(UploadFotoAccFailure('Upload gagal atau URL tidak ditemukan.'));
      }

    });
  }
}
