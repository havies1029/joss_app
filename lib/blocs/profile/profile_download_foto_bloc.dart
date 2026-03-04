import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/repositories/profile/userfoto_repository.dart';

part 'profile_download_foto_event.dart';
part 'profile_download_foto_state.dart';

class ProfileDownloadFotoBloc
    extends Bloc<ProfileDownloadFotoEvent, ProfileDownloadFotoState> {
  final UserFotoRepository repository;

  ProfileDownloadFotoBloc({required this.repository})
      : super(ProfileDownloadFotoInitial()) {
    on<LoadSecureImage>(_onLoadSecureImage);

    // NEW: untuk optimistic preview
    on<SetLocalPreviewImage>(_onSetLocalPreviewImage);
  }

  void _onSetLocalPreviewImage(
      SetLocalPreviewImage event,
      Emitter<ProfileDownloadFotoState> emit,
      ) {
    emit(ProfileDownloadFotoLoaded(event.imageBytes));
  }

  Future<void> _onLoadSecureImage(
      LoadSecureImage event, Emitter<ProfileDownloadFotoState> emit) async {
    debugPrint("_onLoadSecureImage");

    emit(ProfileDownloadFotoLoading());

    try {
      final bytes = await repository.getUserProfileFotoImageBytes();
      if (bytes != null) {
        emit(ProfileDownloadFotoLoaded(bytes));
      } else {
        emit(ProfileDownloadFotoError("Gagal load gambar."));
      }
    } catch (e) {
      emit(ProfileDownloadFotoError(e.toString()));
    }
  }
}