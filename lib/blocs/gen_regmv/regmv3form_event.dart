part of 'regmv3form_bloc.dart';

abstract class Regmv3FormEvents extends Equatable {
	const Regmv3FormEvents();

	@override
	List<Object> get props => [];
}

class Regmv3FormTambahEvent extends Regmv3FormEvents {
	final Regmv3FormModel record;
	const Regmv3FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regmv3FormUbahEvent extends Regmv3FormEvents {
	final Regmv3FormModel record;
	const Regmv3FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regmv3FormHapusEvent extends Regmv3FormEvents {
	final String recordId;
	const Regmv3FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regmv3FormLihatEvent extends Regmv3FormEvents {
	final String recordId;
	const Regmv3FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMWilayahChangedEvent extends Regmv3FormEvents{
	final ComboMWilayahModel comboMWilayah;
	const ComboMWilayahChangedEvent({required this.comboMWilayah});

	@override	List<Object> get props => [comboMWilayah];}

class ComboMMvmerkChangedEvent extends Regmv3FormEvents{
	final ComboMMvmerkModel comboMMvmerk;
	const ComboMMvmerkChangedEvent({required this.comboMMvmerk});

	@override	List<Object> get props => [comboMMvmerk];}

class ComboMMvtipeChangedEvent extends Regmv3FormEvents{
	final ComboMMvtipeModel comboMMvtipe;
	const ComboMMvtipeChangedEvent({required this.comboMMvtipe});

	@override	List<Object> get props => [comboMMvtipe];}

class ComboMMvmodelChangedEvent extends Regmv3FormEvents{
	final ComboMMvmodelModel comboMMvmodel;
	const ComboMMvmodelChangedEvent({required this.comboMMvmodel});

	@override	List<Object> get props => [comboMMvmodel];}

class ComboMWarnaChangedEvent extends Regmv3FormEvents{
	final ComboMWarnaModel comboMWarna;
	const ComboMWarnaChangedEvent({required this.comboMWarna});

	@override	List<Object> get props => [comboMWarna];}

class ComboMMvpakaiChangedEvent extends Regmv3FormEvents{
	final ComboMMvpakaiModel comboMMvpakai;
	const ComboMMvpakaiChangedEvent({required this.comboMMvpakai});

	@override	List<Object> get props => [comboMMvpakai];}

