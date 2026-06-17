part of 'klaimprogresscari_bloc.dart';

abstract class KlaimprogresscariEvents extends Equatable {
	const KlaimprogresscariEvents();

	@override
	List<Object> get props => [];
}

class FetchKlaimprogresscariEvent extends KlaimprogresscariEvents {}

class RefreshKlaimprogresscariEvent extends KlaimprogresscariEvents {
  final String klaim1Id;

  const RefreshKlaimprogresscariEvent({required this.klaim1Id});

  @override
  List<Object> get props => [klaim1Id];
}

class InjectDummyKlaimprogresscariEvent extends KlaimprogresscariEvents {
  final String klaim1Id;

  const InjectDummyKlaimprogresscariEvent({
    required this.klaim1Id,
  });

  @override
  List<Object> get props => [klaim1Id];
}