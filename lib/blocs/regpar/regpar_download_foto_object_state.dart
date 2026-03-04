import 'package:equatable/equatable.dart';

abstract class RegparDownloadFotoObjectState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DownloadInitial extends RegparDownloadFotoObjectState {}

class DownloadLoading extends RegparDownloadFotoObjectState {}

class DownloadSuccess extends RegparDownloadFotoObjectState {
  final String filePath;
  DownloadSuccess(this.filePath);
  @override
  List<Object?> get props => [filePath];
}

class DownloadFailure extends RegparDownloadFotoObjectState {
  final String message;
  DownloadFailure(this.message);
  @override
  List<Object?> get props => [message];
}
