import 'package:equatable/equatable.dart';

abstract class RegmvDownloadFotoAccState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DownloadInitial extends RegmvDownloadFotoAccState {}

class DownloadLoading extends RegmvDownloadFotoAccState {}

class DownloadSuccess extends RegmvDownloadFotoAccState {
  final String filePath;
  DownloadSuccess(this.filePath);
  @override
  List<Object?> get props => [filePath];
}

class DownloadFailure extends RegmvDownloadFotoAccState {
  final String message;
  DownloadFailure(this.message);
  @override
  List<Object?> get props => [message];
}
