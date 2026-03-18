part of 'mrekangeneralidvcrud_bloc.dart';

abstract class MRekanGeneralIdvCrudEvents extends Equatable {
	const MRekanGeneralIdvCrudEvents();

	@override
	List<Object> get props => [];
}

class MRekanGeneralIdvCrudTambahEvent extends MRekanGeneralIdvCrudEvents {
	final MRekanGeneralIdvCrudModel record;
	const MRekanGeneralIdvCrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class MRekanGeneralIdvCrudUbahEvent extends MRekanGeneralIdvCrudEvents {
	final MRekanGeneralIdvCrudModel record;
	const MRekanGeneralIdvCrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class MRekanGeneralIdvCrudHapusEvent extends MRekanGeneralIdvCrudEvents {
	final String recordId;
	const MRekanGeneralIdvCrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class MRekanGeneralIdvCrudLihatEvent extends MRekanGeneralIdvCrudEvents {}

class ComboMPekerjaanChangedEvent extends MRekanGeneralIdvCrudEvents{
	final ComboMPekerjaanModel comboMPekerjaan;
	const ComboMPekerjaanChangedEvent({required this.comboMPekerjaan});

	@override	List<Object> get props => [comboMPekerjaan];
}

class ComboMJnskelChangedEvent extends MRekanGeneralIdvCrudEvents{
	final ComboMJnskelModel comboMJnskel;
	const ComboMJnskelChangedEvent({required this.comboMJnskel});

	@override	List<Object> get props => [comboMJnskel];
}

class MRekanGeneralIdvCrudReloadEvent extends MRekanGeneralIdvCrudEvents {}

class MRekanGeneralIdvCrudResetStatusEvent extends MRekanGeneralIdvCrudEvents {}