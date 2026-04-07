part of 'profile_download_foto_bloc.dart';

abstract class ProfileDownloadFotoEvent {}

class LoadSecureImage extends ProfileDownloadFotoEvent {
  LoadSecureImage();
}

class SetLocalPreviewImage extends ProfileDownloadFotoEvent {
  final Uint8List imageBytes;
  SetLocalPreviewImage(this.imageBytes);
}

class RefreshSecureImage extends ProfileDownloadFotoEvent {}

class ClearAndLoadSecureImage extends ProfileDownloadFotoEvent {
  ClearAndLoadSecureImage();
}

class ClearSecureImage extends ProfileDownloadFotoEvent {
  ClearSecureImage();
}