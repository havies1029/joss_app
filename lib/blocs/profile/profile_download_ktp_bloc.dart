import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/repositories/profile/userfoto_repository.dart';

part 'profile_download_ktp_event.dart';
part 'profile_download_ktp_state.dart';

class ProfileDownloadKtpBloc
    extends Bloc<ProfileDownloadKtpEvent, ProfileDownloadKtpState> {
  final UserFotoRepository repository;

  ProfileDownloadKtpBloc({required this.repository})
      : super(ProfileDownloadKtpInitial()) {
    on<LoadSecureImage>(_onLoadSecureImage);
  }

  Future<void> _onLoadSecureImage(
      LoadSecureImage event, Emitter<ProfileDownloadKtpState> emit) async {
    debugPrint("_onLoadSecureImage");

    emit(ProfileDownloadKtpLoading());

    try {
      final bytes = await repository.getUserProfileFotoImageBytes();
      if (bytes != null) {
        emit(ProfileDownloadKtpLoaded(bytes));
      } else {
        emit(ProfileDownloadKtpError("Gagal load gambar."));
      }
    } catch (e) {
      emit(ProfileDownloadKtpError(e.toString()));
    }
  }
}
