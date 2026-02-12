part of 'progressindicator_bloc.dart';

abstract class ProgressIndicatorEvents extends Equatable {
  const ProgressIndicatorEvents();

  @override
  List<Object> get props => [];
}

class EndProcessEvent extends ProgressIndicatorEvents {
  final String progressName;
  const EndProcessEvent({required this.progressName});

  @override
  List<Object> get props => [progressName];
}

class UpdateProgressEvent extends ProgressIndicatorEvents {
  final double progress;

  const UpdateProgressEvent({required this.progress});

  @override
  List<Object> get props => [progress];
}
