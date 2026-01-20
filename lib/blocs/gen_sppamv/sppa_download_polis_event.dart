part of 'sppa_download_polis_bloc.dart';

abstract class SppaDownloadPolisEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DownloadFileEvent extends SppaDownloadPolisEvent {
  final String ePolisId;
  final String cob;

  DownloadFileEvent({required this.ePolisId, required this.cob});

  @override
  List<Object?> get props => [ePolisId, cob];
}
