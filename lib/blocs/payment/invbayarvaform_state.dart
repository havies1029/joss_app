part of 'invbayarvaform_bloc.dart';

class InvbayarvaFormState extends Equatable {
  final InvbayarvaFormModel? record;
  final bool isPollingVa;
  final bool isPollingStatus;
  final bool isInitialLoading;

  const InvbayarvaFormState({
    this.record,
    this.isPollingVa = false,
    this.isPollingStatus = false,
    this.isInitialLoading = false,
  });

  InvbayarvaFormState copyWith({
    InvbayarvaFormModel? record,
    bool? isPollingVa,
    bool? isPollingStatus,
    bool? isInitialLoading,
  }) {
    return InvbayarvaFormState(
      record: record ?? this.record,
      isPollingVa: isPollingVa ?? this.isPollingVa,
      isPollingStatus: isPollingStatus ?? this.isPollingStatus,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
    );
  }

  @override
  List<Object?> get props => [
    record,
    isPollingVa,
    isPollingStatus,
    isInitialLoading,
  ];
}