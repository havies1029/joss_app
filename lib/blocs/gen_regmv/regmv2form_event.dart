part of 'regmv2form_bloc.dart';

abstract class Regmv2FormEvents extends Equatable {
	const Regmv2FormEvents();

	@override
	List<Object> get props => [];
}

class Regmv2FormTambahEvent extends Regmv2FormEvents {
	final Regmv2FormModel record;
	const Regmv2FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regmv2FormUbahEvent extends Regmv2FormEvents {
	final Regmv2FormModel record;
	const Regmv2FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regmv2FormHapusEvent extends Regmv2FormEvents {
	final String recordId;
	const Regmv2FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regmv2FormLihatEvent extends Regmv2FormEvents {
	final String recordId;
	const Regmv2FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMMvjnscoverChangedEvent extends Regmv2FormEvents{
	final ComboMMvjnscoverModel comboMMvjnscover;
	const ComboMMvjnscoverChangedEvent({required this.comboMMvjnscover});

	@override	List<Object> get props => [comboMMvjnscover];}

class ComboRMatauangChangedEvent extends Regmv2FormEvents{
	final ComboRMatauangModel comboRMatauang;
	const ComboRMatauangChangedEvent({required this.comboRMatauang});

	@override	List<Object> get props => [comboRMatauang];}

class Regmv2DraftEvent extends Regmv2FormEvents {
	final Regmv2FormModel record;
	const Regmv2DraftEvent({required this.record});

	@override
	List<Object> get props => [record];
}
