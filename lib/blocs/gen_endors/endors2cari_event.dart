part of 'endors2cari_bloc.dart';

abstract class Endors2CariEvents extends Equatable {
	const Endors2CariEvents();

	@override
	List<Object> get props => [];
}

class FetchEndors2CariEvent extends Endors2CariEvents {}

class RefreshEndors2CariEvent extends Endors2CariEvents {}

