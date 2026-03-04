part of 'mrekanpiccrud_bloc.dart';

abstract class MRekanPicCrudEvents extends Equatable {
	const MRekanPicCrudEvents();

	@override
	List<Object> get props => [];
}

class MRekanPicCrudTambahEvent extends MRekanPicCrudEvents {
	final MRekanPicCrudModel record;
	const MRekanPicCrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class MRekanPicCrudUbahEvent extends MRekanPicCrudEvents {
	final MRekanPicCrudModel record;
	const MRekanPicCrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class MRekanPicCrudHapusEvent extends MRekanPicCrudEvents {
	final String recordId;
	const MRekanPicCrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class MRekanPicCrudLihatEvent extends MRekanPicCrudEvents {
	final String recordId;
	const MRekanPicCrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMJabatanChangedEvent extends MRekanPicCrudEvents{
	final ComboMJabatanModel comboMJabatan;
	const ComboMJabatanChangedEvent({required this.comboMJabatan});

	@override	List<Object> get props => [comboMJabatan];}

class CheckboxIsDefaultChangedEvent extends MRekanPicCrudEvents {
	final bool isChecked;
	const CheckboxIsDefaultChangedEvent({required this.isChecked});

	@override
	List<Object> get props => [isChecked];
}

class MRekanPicCrudResetEvent extends MRekanPicCrudEvents {}
