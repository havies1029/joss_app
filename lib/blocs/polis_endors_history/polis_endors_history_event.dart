part of 'polis_endors_history_bloc.dart';

abstract class PolisEndorsHistoryEvent extends Equatable {
  const PolisEndorsHistoryEvent();

  @override
  List<Object?> get props => const [];
}

class RefreshPolisEndorsHistoryEvent extends PolisEndorsHistoryEvent {
  final PolisEndorsHistoryCob cob;
  final String polis2Id;
  final String searchText;

  const RefreshPolisEndorsHistoryEvent({
    required this.cob,
    required this.polis2Id,
    this.searchText = '',
  });

  @override
  List<Object?> get props => [cob, polis2Id, searchText];
}

class FetchPolisEndorsHistoryEvent extends PolisEndorsHistoryEvent {
  const FetchPolisEndorsHistoryEvent();
}
