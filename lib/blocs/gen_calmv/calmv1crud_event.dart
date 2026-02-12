part of 'calmv1crud_bloc.dart';

abstract class Calmv1CrudEvents extends Equatable {
	const Calmv1CrudEvents();

	@override
	List<Object> get props => [];
}

class Calmv1CrudTambahEvent extends Calmv1CrudEvents {
	final Calmv1CrudModel record;
	const Calmv1CrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calmv1CrudUbahEvent extends Calmv1CrudEvents {
	final Calmv1CrudModel record;
	const Calmv1CrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calmv1CrudHapusEvent extends Calmv1CrudEvents {
	final String recordId;
	const Calmv1CrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Calmv1CrudLihatEvent extends Calmv1CrudEvents {
	final String recordId;
	const Calmv1CrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMMvjnscoverChangedEvent extends Calmv1CrudEvents{
	final ComboMMvjnscoverModel comboMMvjnscover;
	const ComboMMvjnscoverChangedEvent({required this.comboMMvjnscover});

	@override	List<Object> get props => [comboMMvjnscover];}

class ComboMWilayahChangedEvent extends Calmv1CrudEvents{
	final ComboMWilayahModel comboMWilayah;
	const ComboMWilayahChangedEvent({required this.comboMWilayah});

	@override	List<Object> get props => [comboMWilayah];}

class ComboMMvgrupOjkChangedEvent extends Calmv1CrudEvents{
	final ComboMMvgrupOjkModel comboMMvgrupOjk;
	const ComboMMvgrupOjkChangedEvent({required this.comboMMvgrupOjk});

	@override	List<Object> get props => [comboMMvgrupOjk];}

class ComboMMvpakaiChangedEvent extends Calmv1CrudEvents{
	final ComboMMvpakaiModel comboMMvpakai;
	const ComboMMvpakaiChangedEvent({required this.comboMMvpakai});

	@override	List<Object> get props => [comboMMvpakai];}

class ComboRMatauangChangedEvent extends Calmv1CrudEvents{
	final ComboRMatauangModel comboRMatauang;
	const ComboRMatauangChangedEvent({required this.comboRMatauang});

	@override	List<Object> get props => [comboRMatauang];}

class Calmv1DraftEvent extends Calmv1CrudEvents {
	final Calmv1CrudModel record;
	const Calmv1DraftEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calmv1ResetStatusEvent extends Calmv1CrudEvents {
	const Calmv1ResetStatusEvent();
}