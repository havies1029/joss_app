part of 'loading_flow_bloc.dart';

abstract class LoadingFlowEvent extends Equatable {
  const LoadingFlowEvent();
  @override
  List<Object?> get props => [];
}

class LoadingFlowStartEvent extends LoadingFlowEvent {
  final String cobId;
  final String statusId;
  final String searchText;

  /// biar gak nyangkut kalau ada request error/hang
  final int timeoutMs;

  const LoadingFlowStartEvent({
    required this.cobId,
    required this.statusId,
    required this.searchText,
    this.timeoutMs = 15000,
  });

  @override
  List<Object?> get props => [cobId, statusId, searchText, timeoutMs];
}

class LoadingFlowResetEvent extends LoadingFlowEvent {
  const LoadingFlowResetEvent();
}

class _LoadingFlowCompletedEvent extends LoadingFlowEvent {
  final bool ok;
  final String? message;
  const _LoadingFlowCompletedEvent({required this.ok, this.message});

  @override
  List<Object?> get props => [ok, message];
}

class _LoadingFlowTimeoutEvent extends LoadingFlowEvent {
  const _LoadingFlowTimeoutEvent();
}
