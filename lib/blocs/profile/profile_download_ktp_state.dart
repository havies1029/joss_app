part of 'profile_download_ktp_bloc.dart';

abstract class ProfileDownloadKtpState {}

class ProfileDownloadKtpInitial extends ProfileDownloadKtpState {}

class ProfileDownloadKtpLoading extends ProfileDownloadKtpState {}

class ProfileDownloadKtpLoaded extends ProfileDownloadKtpState {
  final Uint8List imageBytes;
  ProfileDownloadKtpLoaded(this.imageBytes);
}

class ProfileDownloadKtpError extends ProfileDownloadKtpState {
  final String message;
  ProfileDownloadKtpError(this.message);
}
