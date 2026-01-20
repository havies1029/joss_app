
part of 'sppa_download_polis_bloc.dart';

abstract class SppaDownloadPolisState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DownloadInitial extends SppaDownloadPolisState {}

class DownloadLoading extends SppaDownloadPolisState {}

class DownloadSuccess extends SppaDownloadPolisState {
  final String filePath;
  final String cob;
  DownloadSuccess(this.filePath, this.cob);
  @override
  List<Object?> get props => [filePath, cob];
}

class DownloadFailure extends SppaDownloadPolisState {
  final String message;
  DownloadFailure(this.message);
  @override
  List<Object?> get props => [message];
}
