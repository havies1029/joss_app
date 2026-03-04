part of 'profile_upload_ktp_bloc.dart';

abstract class ProfileUploadKtpState extends Equatable {
  const ProfileUploadKtpState();

  @override
  List<Object?> get props => [];
}

class UploadKtpInitial extends ProfileUploadKtpState {}

class UploadKtpPreview extends ProfileUploadKtpState {
  final Uint8List imageBytes;
  final String fileName;
  const UploadKtpPreview(this.imageBytes, this.fileName);

  @override
  List<Object?> get props => [imageBytes, fileName];
}

class UploadKtpLoading extends ProfileUploadKtpState {}

class UploadKtpSuccess extends ProfileUploadKtpState {}

class UploadKtpFailure extends ProfileUploadKtpState {
  final String error;

  const UploadKtpFailure(this.error);

  @override
  List<Object?> get props => [error];
}
