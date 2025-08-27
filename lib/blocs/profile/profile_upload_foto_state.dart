part of 'profile_upload_foto_bloc.dart';

abstract class ProfileUploadFotoState extends Equatable {
  const ProfileUploadFotoState();

  @override
  List<Object?> get props => [];
}

class ProfileUploadFotoInitial extends ProfileUploadFotoState {}

class ProfileUploadFotoUploading extends ProfileUploadFotoState {}

class ProfileUploadFotoUpdated extends ProfileUploadFotoState {
  final String imageUrl;

  const ProfileUploadFotoUpdated(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

class ProfileUploadFotoFailure extends ProfileUploadFotoState {
  final String error;

  const ProfileUploadFotoFailure(this.error);

  @override
  List<Object?> get props => [error];
}
