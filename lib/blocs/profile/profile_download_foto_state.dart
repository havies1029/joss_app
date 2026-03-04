part of 'profile_download_foto_bloc.dart';

abstract class ProfileDownloadFotoState {}

class ProfileDownloadFotoInitial extends ProfileDownloadFotoState {}

class ProfileDownloadFotoLoading extends ProfileDownloadFotoState {}

class ProfileDownloadFotoLoaded extends ProfileDownloadFotoState {
  final Uint8List imageBytes;
  ProfileDownloadFotoLoaded(this.imageBytes);
}

class ProfileDownloadFotoError extends ProfileDownloadFotoState {
  final String message;
  ProfileDownloadFotoError(this.message);
}
