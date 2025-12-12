import 'package:equatable/equatable.dart';

abstract class RegmvDownloadFotoMobilEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DownloadFileEvent extends RegmvDownloadFotoMobilEvent {
  final String regmv5Id;

  DownloadFileEvent({required this.regmv5Id});

  @override
  List<Object?> get props => [regmv5Id];
}
