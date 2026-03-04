part of 'regklaim1crud_bloc.dart';

abstract class Regklaim1CrudEvents extends Equatable {
	const Regklaim1CrudEvents();

	@override
	List<Object> get props => [];
}

class Regklaim1CrudTambahEvent extends Regklaim1CrudEvents {
	final Regklaim1CrudModel record;
	const Regklaim1CrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regklaim1CrudUbahEvent extends Regklaim1CrudEvents {
	final Regklaim1CrudModel record;
	const Regklaim1CrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regklaim1CrudHapusEvent extends Regklaim1CrudEvents {
	final String recordId;
	const Regklaim1CrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regklaim1CrudLihatEvent extends Regklaim1CrudEvents {
	final String recordId;
	const Regklaim1CrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regklaim1Tambah4PolisJpsEvent extends Regklaim1CrudEvents {
	final String sppa1Id;
	const Regklaim1Tambah4PolisJpsEvent({required this.sppa1Id});

	@override
	List<Object> get props => [sppa1Id];
}

class ComboMInsuranceChangedEvent extends Regklaim1CrudEvents{
	final ComboMInsuranceModel comboMInsurance;
	const ComboMInsuranceChangedEvent({required this.comboMInsurance});

	@override	List<Object> get props => [comboMInsurance];
}

class RegklaimToKlaimEvent extends Regklaim1CrudEvents {
  final String regklaim1Id;
  const RegklaimToKlaimEvent({required this.regklaim1Id});

  @override
  List<Object> get props => [regklaim1Id];
}