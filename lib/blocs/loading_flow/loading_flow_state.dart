part of 'loading_flow_bloc.dart';

enum LoadingFlowStatus { initial, loading, success, failure }

class LoadingFlowState extends Equatable {
  final LoadingFlowStatus status;
  final bool? result; // true/false penanda selesai
  final String? message;

  /// guard biar gak re-trigger
  final bool stepTriggered;

  /// info request terakhir (opsional)
  final String cobId;
  final String statusId;
  final String searchText;

  const LoadingFlowState({
    this.status = LoadingFlowStatus.initial,
    this.result,
    this.message,
    this.stepTriggered = false,
    this.cobId = "",
    this.statusId = "",
    this.searchText = "",
  });

  LoadingFlowState copyWith({
    LoadingFlowStatus? status,
    bool? result,
    String? message,
    bool? stepTriggered,
    String? cobId,
    String? statusId,
    String? searchText,
  }) {
    return LoadingFlowState(
      status: status ?? this.status,
      result: result ?? this.result,
      message: message ?? this.message,
      stepTriggered: stepTriggered ?? this.stepTriggered,
      cobId: cobId ?? this.cobId,
      statusId: statusId ?? this.statusId,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props => [status, result, message, stepTriggered, cobId, statusId, searchText];
}
