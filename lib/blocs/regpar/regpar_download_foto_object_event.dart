import 'package:equatable/equatable.dart';

abstract class RegparDownloadFotoObjectEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DownloadFileEvent extends RegparDownloadFotoObjectEvent {
  final String regpar6Id;

  DownloadFileEvent({required this.regpar6Id});

  @override
  List<Object?> get props => [regpar6Id];
}
