part of 'klaimmvklaimcrud_bloc.dart';

abstract class KlaimmvklaimcrudEvents extends Equatable {
	const KlaimmvklaimcrudEvents();

	@override
	List<Object> get props => [];
}

class KlaimmvklaimcrudTambahEvent extends KlaimmvklaimcrudEvents {
	final KlaimmvklaimcrudModel record;
	const KlaimmvklaimcrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class KlaimmvklaimcrudUbahEvent extends KlaimmvklaimcrudEvents {
	final KlaimmvklaimcrudModel record;
	const KlaimmvklaimcrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class KlaimmvklaimcrudHapusEvent extends KlaimmvklaimcrudEvents {
	final String recordId;
	const KlaimmvklaimcrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class KlaimmvklaimcrudLihatEvent extends KlaimmvklaimcrudEvents {
	final String recordId;
	const KlaimmvklaimcrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboRMatauangChangedEvent extends KlaimmvklaimcrudEvents{
	final ComboRMatauangModel comboRMatauang;
	const ComboRMatauangChangedEvent({required this.comboRMatauang});

	@override	List<Object> get props => [comboRMatauang];
}

class FieldCurrIdChangedEvent extends KlaimmvklaimcrudEvents{
  final String currId;
  const FieldCurrIdChangedEvent({required this.currId});

  @override	List<Object> get props => [currId];
}

class FieldDolChangedEvent extends KlaimmvklaimcrudEvents{
  final DateTime dol;
  const FieldDolChangedEvent({required this.dol});

  @override	List<Object> get props => [dol];
}

class FieldKlaimAmountChangedEvent extends KlaimmvklaimcrudEvents{
  final double klaimAmount;
  const FieldKlaimAmountChangedEvent({required this.klaimAmount});

  @override	List<Object> get props => [klaimAmount];
}

class FieldKronologisChangedEvent extends KlaimmvklaimcrudEvents{
  final String kronologis;
  const FieldKronologisChangedEvent({required this.kronologis});

  @override	List<Object> get props => [kronologis];
}

class KlaimmvklaimAutoSaveEvent extends KlaimmvklaimcrudEvents {}