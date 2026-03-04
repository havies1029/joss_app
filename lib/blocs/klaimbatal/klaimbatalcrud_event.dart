part of 'klaimbatalcrud_bloc.dart';

abstract class KlaimbatalcrudEvents extends Equatable {
	const KlaimbatalcrudEvents();

	@override
	List<Object> get props => [];
}

class KlaimbatalcrudUbahEvent extends KlaimbatalcrudEvents {
	final KlaimbatalcrudModel record;
	const KlaimbatalcrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}


