part of 'sppamvcrud_bloc.dart';

abstract class SppamvCrudEvents extends Equatable {
	const SppamvCrudEvents();

	@override
	List<Object> get props => [];
}

class SppamvCrudTambahEvent extends SppamvCrudEvents {
	final SppamvCrudModel record;
	const SppamvCrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class SppamvCrudUbahEvent extends SppamvCrudEvents {
	final SppamvCrudModel record;
	const SppamvCrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class SppamvCrudHapusEvent extends SppamvCrudEvents {
	final String recordId;
	const SppamvCrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class SppamvCrudLihatEvent extends SppamvCrudEvents {
	final String recordId;
	const SppamvCrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboRMatauangChangedEvent extends SppamvCrudEvents{
	final ComboRMatauangModel comboRMatauang;
	const ComboRMatauangChangedEvent({required this.comboRMatauang});

	@override	List<Object> get props => [comboRMatauang];}

class ComboMMvmerkChangedEvent extends SppamvCrudEvents{
	final ComboMMvmerkModel comboMMvmerk;
	const ComboMMvmerkChangedEvent({required this.comboMMvmerk});

	@override	List<Object> get props => [comboMMvmerk];}

class ComboMMvtipeChangedEvent extends SppamvCrudEvents{
	final ComboMMvtipeModel comboMMvtipe;
	const ComboMMvtipeChangedEvent({required this.comboMMvtipe});

	@override	List<Object> get props => [comboMMvtipe];}

class ComboMMvjnscoverChangedEvent extends SppamvCrudEvents{
	final ComboMMvjnscoverModel comboMMvjnscover;
	const ComboMMvjnscoverChangedEvent({required this.comboMMvjnscover});

	@override	List<Object> get props => [comboMMvjnscover];}

class ComboMWilayahChangedEvent extends SppamvCrudEvents{
	final ComboMWilayahModel comboMWilayah;
	const ComboMWilayahChangedEvent({required this.comboMWilayah});

	@override	List<Object> get props => [comboMWilayah];}

class ComboMMvgrupOjkChangedEvent extends SppamvCrudEvents{
	final ComboMMvgrupOjkModel comboMMvgrupOjk;
	const ComboMMvgrupOjkChangedEvent({required this.comboMMvgrupOjk});

	@override	List<Object> get props => [comboMMvgrupOjk];}

class ComboMWarnaChangedEvent extends SppamvCrudEvents{
	final ComboMWarnaModel comboMWarna;
	const ComboMWarnaChangedEvent({required this.comboMWarna});

	@override	List<Object> get props => [comboMWarna];}

