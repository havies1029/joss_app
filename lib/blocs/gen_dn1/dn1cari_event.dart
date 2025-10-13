part of 'dn1cari_bloc.dart';

abstract class Dn1CariEvents extends Equatable {
	const Dn1CariEvents();

	@override
	List<Object> get props => [];
}

class FetchDn1CariEvent extends Dn1CariEvents {}

class RefreshDn1CariEvent extends Dn1CariEvents {
  final String sppa1Id;

  const RefreshDn1CariEvent({required this.sppa1Id});

  @override
  List<Object> get props => [sppa1Id];

}

