import 'package:equatable/equatable.dart';

abstract class RegmvDownloadFotoStnkEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DownloadFileEvent extends RegmvDownloadFotoStnkEvent {
  final String regmv4Id;

  DownloadFileEvent({required this.regmv4Id});

  @override
  List<Object?> get props => [regmv4Id];
}

