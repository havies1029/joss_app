import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

part 'profile_upload_foto_event.dart';
part 'profile_upload_foto_state.dart';

class ProfileUploadFotoBloc extends Bloc<ProfileUploadFotoEvent, ProfileUploadFotoState> {
  final Dio _dio;
  final _base = AppData.apiDomain;


  ProfileUploadFotoBloc({Dio? dio})
      : _dio = dio ?? Dio(),
        super(ProfileUploadFotoInitial()) {
    on<UploadProfilePicture>(_onUploadAndUpdate);
  }

  Future<void> _onUploadAndUpdate(
    UploadProfilePicture event,
    Emitter<ProfileUploadFotoState> emit,
  ) async {
    emit(ProfileUploadFotoUploading());

    String uploadFotoEndpoint = "api/userprofile/uploadfoto";
    String uploadFotoURL = _base + uploadFotoEndpoint;

    Map<String, String> headers = <String, String>{
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${AppData.userToken}'
    };

    _dio.options.headers = headers;

    try {
      // Step 1: Upload file
      final uploadResponse = await _dio.post(
        uploadFotoURL,
        data: FormData.fromMap({
          'file': MultipartFile.fromBytes(event.bytes, filename: event.fileName),
        }),
      );

      if (uploadResponse.statusCode == 200 && uploadResponse.data['url'] != null) {       
       
      } else {
        emit(ProfileUploadFotoFailure('Upload gagal atau URL tidak ditemukan.'));
      }
    } catch (e) {
      emit(ProfileUploadFotoFailure('Terjadi error: ${e.toString()}'));
    }
  }
}
