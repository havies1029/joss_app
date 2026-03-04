part of 'regpar4form_bloc.dart';

abstract class Regpar4FormEvents extends Equatable {
	const Regpar4FormEvents();

	@override
	List<Object> get props => [];
}

class Regpar4FormTambahEvent extends Regpar4FormEvents {
	final Regpar4FormModel record;
	const Regpar4FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regpar4FormUbahEvent extends Regpar4FormEvents {
	final Regpar4FormModel record;
	const Regpar4FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regpar4FormHapusEvent extends Regpar4FormEvents {
	final String recordId;
	const Regpar4FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regpar4FormLihatEvent extends Regpar4FormEvents {
	final String recordId;
	const Regpar4FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboRMatauangChangedEvent extends Regpar4FormEvents{
	final ComboRMatauangModel comboRMatauang;
	const ComboRMatauangChangedEvent({required this.comboRMatauang});

	@override	List<Object> get props => [comboRMatauang];}

class Regpar4DraftEvent extends Regpar4FormEvents {
	final Regpar4FormModel record;
	const Regpar4DraftEvent({required this.record});

	@override
	List<Object> get props => [record];
}
