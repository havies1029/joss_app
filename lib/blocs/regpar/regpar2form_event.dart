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

class ComboMPropinsiChangedEvent extends Regpar2FormEvents{
	final ComboMPropinsiModel comboMPropinsi;
	const ComboMPropinsiChangedEvent({required this.comboMPropinsi});

	@override	List<Object> get props => [comboMPropinsi];}

class ComboMKotaChangedEvent extends Regpar2FormEvents{
	final ComboMKotaModel comboMKota;
	const ComboMKotaChangedEvent({required this.comboMKota});

	@override	List<Object> get props => [comboMKota];}

class ComboMKecamatanChangedEvent extends Regpar2FormEvents{
	final ComboMKecamatanModel comboMKecamatan;
	const ComboMKecamatanChangedEvent({required this.comboMKecamatan});

	@override	List<Object> get props => [comboMKecamatan];}

class ComboMKelurahanChangedEvent extends Regpar2FormEvents{
	final ComboMKelurahanModel comboMKelurahan;
	const ComboMKelurahanChangedEvent({required this.comboMKelurahan});

	@override	List<Object> get props => [comboMKelurahan];}

class FieldPolisMulaiChangedEvent extends Regpar2FormEvents {
	final DateTime polisMulai;
	const FieldPolisMulaiChangedEvent({required this.polisMulai});

	@override
	List<Object> get props => [polisMulai];
}

class FieldPolisAkhirChangedEvent extends Regpar2FormEvents {
	final DateTime polisAkhir;
	const FieldPolisAkhirChangedEvent({required this.polisAkhir});

	@override
	List<Object> get props => [polisAkhir];
}

class FieldObjectAlamatChangedEvent extends Regpar2FormEvents {
	final String objectAlamat;
	const FieldObjectAlamatChangedEvent({required this.objectAlamat});

	@override
	List<Object> get props => [objectAlamat];
}

class Regpar2DraftEvent extends Regpar2FormEvents {
	final Regpar2FormModel record;
	const Regpar2DraftEvent({required this.record});

	@override
	List<Object> get props => [record];
}

