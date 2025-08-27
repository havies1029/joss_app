part of 'sppaparcrud_bloc.dart';

abstract class SppaparCrudEvents extends Equatable {
	const SppaparCrudEvents();

	@override
	List<Object> get props => [];
}

class SppaparCrudTambahEvent extends SppaparCrudEvents {
	final SppaparCrudModel record;
	const SppaparCrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class SppaparCrudUbahEvent extends SppaparCrudEvents {
	final SppaparCrudModel record;
	const SppaparCrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class SppaparCrudHapusEvent extends SppaparCrudEvents {
	final String recordId;
	const SppaparCrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class SppaparCrudLihatEvent extends SppaparCrudEvents {
	final String recordId;
	const SppaparCrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboRMatauangChangedEvent extends SppaparCrudEvents{
	final ComboRMatauangModel comboRMatauang;
	const ComboRMatauangChangedEvent({required this.comboRMatauang});

	@override	List<Object> get props => [comboRMatauang];}

class ComboROkupasiChangedEvent extends SppaparCrudEvents{
	final ComboROkupasiModel comboROkupasi;
	const ComboROkupasiChangedEvent({required this.comboROkupasi});

	@override	List<Object> get props => [comboROkupasi];}

class ComboRKonstruksiojkChangedEvent extends SppaparCrudEvents{
	final ComboRKonstruksiojkModel comboRKonstruksiojk;
	const ComboRKonstruksiojkChangedEvent({required this.comboRKonstruksiojk});

	@override	List<Object> get props => [comboRKonstruksiojk];}

class ComboMBiindemnityOjkChangedEvent extends SppaparCrudEvents{
	final ComboMBiindemnityOjkModel comboMBiindemnityOjk;
	const ComboMBiindemnityOjkChangedEvent({required this.comboMBiindemnityOjk});

	@override	List<Object> get props => [comboMBiindemnityOjk];}

class ComboMKabZonaGempaChangedEvent extends SppaparCrudEvents{
	final ComboMKabZonaGempaModel comboMKabZonaGempa;
	const ComboMKabZonaGempaChangedEvent({required this.comboMKabZonaGempa});

	@override	List<Object> get props => [comboMKabZonaGempa];}

class ComboMWilayahChangedEvent extends SppaparCrudEvents{
	final ComboMWilayahModel comboMWilayah;
	const ComboMWilayahChangedEvent({required this.comboMWilayah});

	@override	List<Object> get props => [comboMWilayah];}

class ComboMTarifojkBanjirParChangedEvent extends SppaparCrudEvents{
	final ComboMTarifojkBanjirParModel comboMTarifojkBanjirPar;
	const ComboMTarifojkBanjirParChangedEvent({required this.comboMTarifojkBanjirPar});

	@override	List<Object> get props => [comboMTarifojkBanjirPar];}

class ComboRKodeposChangedEvent extends SppaparCrudEvents{
	final ComboRKodeposModel comboRKodepos;
	const ComboRKodeposChangedEvent({required this.comboRKodepos});

	@override	List<Object> get props => [comboRKodepos];}

