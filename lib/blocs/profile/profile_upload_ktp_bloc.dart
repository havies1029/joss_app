import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:joss_app/repositories/profile/profile_ktp_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_upload_ktp_event.dart';
part 'profile_upload_ktp_state.dart';

class ProfileUploadKtpBloc
    extends Bloc<ProfileUploadKtpEvent, ProfileUploadKtpState> {
  final ProfileKtpRepository repository;
  Uint8List? _selectedImage;
  String? _fileName;

  ProfileUploadKtpBloc({required this.repository})
      : super(UploadKtpInitial()) {
    on<UploadKtpSelected>((event, emit) {
      _selectedImage = event.imageBytes;
      _fileName = event.fileName;
      emit(UploadKtpPreview(event.imageBytes, event.fileName));
    });

    on<UploadKtpSubmitted>((event, emit) async {
      emit(UploadKtpLoading());

      var success = await repository.uploadKtp(_selectedImage!, _fileName!);

      if (success){
        emit(UploadKtpSuccess());
      }
      else {
        emit(UploadKtpFailure('Upload gagal atau URL tidak ditemukan.'));
      }

    });
  }
}
