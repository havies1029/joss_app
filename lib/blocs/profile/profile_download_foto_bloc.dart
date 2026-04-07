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
    on<RefreshSecureImage>(_onRefreshSecureImage);
    on<ClearAndLoadSecureImage>(_onClearAndLoadSecureImage);
    on<SetLocalPreviewImage>(_onSetLocalPreviewImage);
    on<ClearSecureImage>(_onClearSecureImage);
  }

  void _onClearSecureImage(
      ClearSecureImage event,
      Emitter<ProfileDownloadFotoState> emit,
      ) {
    emit(ProfileDownloadFotoInitial());
  }

  Future<void> _onLoadSecureImage(
      LoadSecureImage event,
      Emitter<ProfileDownloadFotoState> emit,
      ) async {

    emit(ProfileDownloadFotoInitial());
    emit(ProfileDownloadFotoLoading());

    try {
      final bytes = await repository.getUserProfileFotoImageBytes();
      debugPrint("Bytes null: ${bytes == null}");
      debugPrint("Bytes length: ${bytes?.length ?? 0}");

      if (bytes != null && bytes.isNotEmpty) {
        emit(ProfileDownloadFotoLoaded(bytes));
      } else {
        emit(ProfileDownloadFotoError("Gagal load gambar."));
      }
    } catch (e) {
      debugPrint("Error clear and load: $e");
      emit(ProfileDownloadFotoError(e.toString()));
    }
  }

  Future<void> _onRefreshSecureImage(
      RefreshSecureImage event,
      Emitter<ProfileDownloadFotoState> emit,
      ) async {
    debugPrint("_onRefreshSecureImage");

    emit(ProfileDownloadFotoLoading());

    try {
      final bytes = await repository.getUserProfileFotoImageBytes();
      if (bytes != null && bytes.isNotEmpty) {
        emit(ProfileDownloadFotoLoaded(bytes));
      } else {
        emit(ProfileDownloadFotoError("Gagal load gambar."));
      }
    } catch (e) {
      emit(ProfileDownloadFotoError(e.toString()));
    }
  }

  Future<void> _onClearAndLoadSecureImage(
      ClearAndLoadSecureImage event,
      Emitter<ProfileDownloadFotoState> emit,
      ) async {
    debugPrint("_onClearAndLoadSecureImage");
    debugPrint("Clear state lama -> loading -> fetch ulang");

    emit(ProfileDownloadFotoInitial());
    emit(ProfileDownloadFotoLoading());

    try {
      final bytes = await repository.getUserProfileFotoImageBytes();
      debugPrint("Bytes null: ${bytes == null}");
      debugPrint("Bytes length: ${bytes?.length ?? 0}");

      if (bytes != null && bytes.isNotEmpty) {
        emit(ProfileDownloadFotoLoaded(bytes));
      } else {
        emit(ProfileDownloadFotoError("Gagal load gambar."));
      }
    } catch (e) {
      debugPrint("Error clear and load: $e");
      emit(ProfileDownloadFotoError(e.toString()));
    }
  }

  void _onSetLocalPreviewImage(
      SetLocalPreviewImage event,
      Emitter<ProfileDownloadFotoState> emit,
      ) {
    debugPrint("_onSetLocalPreviewImage");
    debugPrint("Preview bytes length: ${event.imageBytes.length}");

    emit(ProfileDownloadFotoLoaded(event.imageBytes));
  }
}