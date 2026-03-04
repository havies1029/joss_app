part of 'invbayarvaform_bloc.dart';

class InvbayarvaFormState extends Equatable {
  final InvbayarvaFormModel? record;
  final bool isPollingVa;
  final bool isPollingStatus;

  const InvbayarvaFormState({
    this.record,
    this.isPollingVa = false,
    this.isPollingStatus = false,
  });

  InvbayarvaFormState copyWith({
    InvbayarvaFormModel? record,
    bool? isPollingVa,
    bool? isPollingStatus,
  }) {
    return InvbayarvaFormState(
      record: record ?? this.record,
      isPollingVa: isPollingVa ?? this.isPollingVa,
      isPollingStatus: isPollingStatus ?? this.isPollingStatus,
    );
  }

  @override
  List<Object?> get props => [
        record,
        isPollingVa,
        isPollingStatus,
      ];
}