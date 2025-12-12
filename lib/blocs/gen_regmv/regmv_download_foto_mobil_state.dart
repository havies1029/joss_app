import 'package:equatable/equatable.dart';

abstract class RegmvDownloadFotoMobilState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DownloadInitial extends RegmvDownloadFotoMobilState {}

class DownloadLoading extends RegmvDownloadFotoMobilState {}

class DownloadSuccess extends RegmvDownloadFotoMobilState {
  final String filePath;
  DownloadSuccess(this.filePath);
  @override
  List<Object?> get props => [filePath];
}

class DownloadFailure extends RegmvDownloadFotoMobilState {
  final String message;
  DownloadFailure(this.message);
  @override
  List<Object?> get props => [message];
}
