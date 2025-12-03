part of 'regpar2form_bloc.dart';

abstract class Regpar2FormEvents extends Equatable {
	const Regpar2FormEvents();

	@override
	List<Object> get props => [];
}

class Regpar2FormTambahEvent extends Regpar2FormEvents {
	final Regpar2FormModel record;
	const Regpar2FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regpar2FormUbahEvent extends Regpar2FormEvents {
	final Regpar2FormModel record;
	const Regpar2FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regpar2FormHapusEvent extends Regpar2FormEvents {
	final String recordId;
	const Regpar2FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regpar2FormLihatEvent extends Regpar2FormEvents {
	final String recordId;
	const Regpar2FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboROkupasiChangedEvent extends Regpar2FormEvents{
	final ComboROkupasiModel comboROkupasi;
	const ComboROkupasiChangedEvent({required this.comboROkupasi});

	@override	List<Object> get props => [comboROkupasi];}

class ComboRKonstruksiojkChangedEvent extends Regpar2FormEvents{
	final ComboRKonstruksiojkModel comboRKonstruksiojk;
	const ComboRKonstruksiojkChangedEvent({required this.comboRKonstruksiojk});

	@override	List<Object> get props => [comboRKonstruksiojk];}

