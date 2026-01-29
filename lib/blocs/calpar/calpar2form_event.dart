part of 'calpar2form_bloc.dart';

abstract class Calpar2FormEvents extends Equatable {
	const Calpar2FormEvents();

	@override
	List<Object> get props => [];
}

class Calpar2FormTambahEvent extends Calpar2FormEvents {
	final Calpar2FormModel record;
	const Calpar2FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calpar2FormUbahEvent extends Calpar2FormEvents {
	final Calpar2FormModel record;
	const Calpar2FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calpar2FormHapusEvent extends Calpar2FormEvents {
	final String recordId;
	const Calpar2FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Calpar2FormLihatEvent extends Calpar2FormEvents {
	final String recordId;
	const Calpar2FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboRMatauangChangedEvent extends Calpar2FormEvents{
	final ComboRMatauangModel comboRMatauang;
	const ComboRMatauangChangedEvent({required this.comboRMatauang});

	@override	List<Object> get props => [comboRMatauang];}

class ComboMBiindemnityOjkChangedEvent extends Calpar2FormEvents{
	final ComboMBiindemnityOjkModel comboMBiindemnityOjk;
	const ComboMBiindemnityOjkChangedEvent({required this.comboMBiindemnityOjk});

	@override	List<Object> get props => [comboMBiindemnityOjk];}

class Calpar2DraftEvent extends Calpar2FormEvents {
	final Calpar2FormModel record;
	const Calpar2DraftEvent({required this.record});

	@override
	List<Object> get props => [record];
}
