part of 'progressindicator_bloc.dart';

class ProgressIndicatorState extends Equatable {
  final String progressName;
  final bool downloading;
  final bool downloaded;
  final double progressPercent;

  const ProgressIndicatorState(
      {this.progressName = "",
      this.downloading = false,
      this.downloaded = false,
      this.progressPercent = 0});

  ProgressIndicatorState copyWith(
      {progressName, downloading, downloaded, progressPercent}) {
    return ProgressIndicatorState(
        progressName: progressName ?? this.progressName,
        downloading: downloading ?? this.downloading,
        downloaded: downloaded ?? this.downloaded,
        progressPercent: progressPercent ?? this.progressPercent);
  }

  @override
  List<Object> get props => [progressName, downloading, downloaded, progressPercent];
}
