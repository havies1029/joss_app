part of 'invbayarvaform_bloc.dart';

abstract class InvbayarvaFormEvents extends Equatable {
	const InvbayarvaFormEvents();

	@override
	List<Object> get props => [];
}

class InvbayarvaFormLihatEvent extends InvbayarvaFormEvents {
	final String invoiceId;
	const InvbayarvaFormLihatEvent({required this.invoiceId});

	@override
	List<Object> get props => [invoiceId];
}



