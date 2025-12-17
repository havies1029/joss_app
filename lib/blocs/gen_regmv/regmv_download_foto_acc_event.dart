import 'package:equatable/equatable.dart';

abstract class RegmvDownloadFotoAccEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DownloadFileEvent extends RegmvDownloadFotoAccEvent {
  final String regmv7Id;

  DownloadFileEvent({required this.regmv7Id});

  @override
  List<Object?> get props => [regmv7Id];
}
