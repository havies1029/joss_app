part of 'rekanbank_bloc.dart';

abstract class RekanBankEvents extends Equatable {
	const RekanBankEvents();

	@override
	List<Object> get props => [];
}

class RekanBankTambahEvent extends RekanBankEvents {
	final RekanBankModel record;
	const RekanBankTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class RekanBankUbahEvent extends RekanBankEvents {
	final RekanBankModel record;
	const RekanBankUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class RekanBankHapusEvent extends RekanBankEvents {
	final String recordId;
	const RekanBankHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class RekanBankLihatEvent extends RekanBankEvents {
	final String recordId;
	const RekanBankLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMBankChangedEvent extends RekanBankEvents{
	final ComboMBankModel comboMBank;
	const ComboMBankChangedEvent({required this.comboMBank});

	@override	List<Object> get props => [comboMBank];}

