part of 'invbayarvaform_bloc.dart';

abstract class InvbayarvaFormEvents extends Equatable {
	const InvbayarvaFormEvents();

	@override
	List<Object> get props => [];
}

class InvbayarvaFormTambahEvent extends InvbayarvaFormEvents {
	final InvbayarvaFormModel record;
	const InvbayarvaFormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class InvbayarvaFormUbahEvent extends InvbayarvaFormEvents {
	final InvbayarvaFormModel record;
	const InvbayarvaFormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class InvbayarvaFormHapusEvent extends InvbayarvaFormEvents {
	final String recordId;
	const InvbayarvaFormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class InvbayarvaFormLihatEvent extends InvbayarvaFormEvents {
	final String invoiceId;
	const InvbayarvaFormLihatEvent({required this.invoiceId});

	@override
	List<Object> get props => [invoiceId];
}

class ComboMBankChangedEvent extends InvbayarvaFormEvents{
	final ComboMBankModel comboMBank;
	const ComboMBankChangedEvent({required this.comboMBank});

	@override	List<Object> get props => [comboMBank];}

