part of 'profile_upload_foto_bloc.dart';

abstract class ProfileUploadFotoEvent extends Equatable {
  const ProfileUploadFotoEvent();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileUploadFotoEvent {}

class UploadProfilePicture extends ProfileUploadFotoEvent {
  final Uint8List bytes;
  final String fileName;

  const UploadProfilePicture(this.bytes, this.fileName);

  @override
  List<Object?> get props => [bytes, fileName];
}

class ProfilePicUpdateFailed extends ProfileUploadFotoEvent {
  final String message;
  const ProfilePicUpdateFailed(this.message);

  @override
  List<Object?> get props => [message];
}