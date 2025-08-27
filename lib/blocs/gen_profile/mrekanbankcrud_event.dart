part of 'mrekanbankcrud_bloc.dart';

abstract class MRekanBankCrudEvents extends Equatable {
	const MRekanBankCrudEvents();

	@override
	List<Object> get props => [];
}

class MRekanBankCrudTambahEvent extends MRekanBankCrudEvents {
	final MRekanBankCrudModel record;
	const MRekanBankCrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class MRekanBankCrudUbahEvent extends MRekanBankCrudEvents {
	final MRekanBankCrudModel record;
	const MRekanBankCrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class MRekanBankCrudHapusEvent extends MRekanBankCrudEvents {
	final String recordId;
	const MRekanBankCrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class MRekanBankCrudLihatEvent extends MRekanBankCrudEvents {
	final String recordId;
	const MRekanBankCrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMBankChangedEvent extends MRekanBankCrudEvents{
	final ComboMBankModel comboMBank;
	const ComboMBankChangedEvent({required this.comboMBank});

	@override	List<Object> get props => [comboMBank];}

class MRekanBankCrudResetStatusEvent extends MRekanBankCrudEvents {}
