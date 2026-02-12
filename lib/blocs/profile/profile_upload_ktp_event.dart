part of 'profile_upload_ktp_bloc.dart';

abstract class ProfileUploadKtpEvent extends Equatable {
  const ProfileUploadKtpEvent();

  @override
  List<Object?> get props => [];
}

class UploadKtpSelected extends ProfileUploadKtpEvent {
  final Uint8List imageBytes;
  final String fileName;
  const UploadKtpSelected(this.imageBytes, this.fileName);

  @override
  List<Object?> get props => [imageBytes, fileName];
}

class UploadKtpSubmitted extends ProfileUploadKtpEvent {}

class CekIsKtpUploaded extends ProfileUploadKtpEvent {
  final String mrekanId;
  const CekIsKtpUploaded(this.mrekanId);

  @override
  List<Object?> get props => [mrekanId];
}