part of 'klaimmvstatuscari_bloc.dart';

abstract class KlaimmvstatuscariEvents extends Equatable {
	const KlaimmvstatuscariEvents();

	@override
	List<Object> get props => [];
}

class FetchKlaimmvstatuscariEvent extends KlaimmvstatuscariEvents {}

class RefreshKlaimmvstatuscariEvent extends KlaimmvstatuscariEvents {
  final String klaim1Id;
  const RefreshKlaimmvstatuscariEvent({required this.klaim1Id});

  @override
  List<Object> get props => [klaim1Id];
}

