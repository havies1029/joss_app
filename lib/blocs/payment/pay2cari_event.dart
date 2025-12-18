part of 'pay2cari_bloc.dart';

abstract class Pay2CariEvents extends Equatable {
	const Pay2CariEvents();

	@override
	List<Object> get props => [];
}

class FetchPay2CariEvent extends Pay2CariEvents {}

class RefreshPay2CariEvent extends Pay2CariEvents {
	final String ar1Id;

	const RefreshPay2CariEvent({required this.ar1Id});

	@override
	List<Object> get props => [ar1Id];
}

