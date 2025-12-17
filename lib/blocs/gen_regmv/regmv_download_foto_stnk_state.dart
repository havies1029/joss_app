import 'package:equatable/equatable.dart';

abstract class RegmvDownloadFotoStnkState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DownloadInitial extends RegmvDownloadFotoStnkState {}

class DownloadLoading extends RegmvDownloadFotoStnkState {}

class DownloadSuccess extends RegmvDownloadFotoStnkState {
  final String filePath;
  DownloadSuccess(this.filePath);
  @override
  List<Object?> get props => [filePath];
}

class DownloadFailure extends RegmvDownloadFotoStnkState {
  final String message;
  DownloadFailure(this.message);
  @override
  List<Object?> get props => [message];
}
