part of 'klaimmvpoliscrud_bloc.dart';

abstract class KlaimmvpoliscrudEvents extends Equatable {
	const KlaimmvpoliscrudEvents();

	@override
	List<Object> get props => [];
}

class KlaimmvpoliscrudTambahEvent extends KlaimmvpoliscrudEvents {
	final KlaimmvpoliscrudModel record;
	const KlaimmvpoliscrudTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class KlaimmvpoliscrudUbahEvent extends KlaimmvpoliscrudEvents {
	final KlaimmvpoliscrudModel record;
	const KlaimmvpoliscrudUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class KlaimmvpoliscrudHapusEvent extends KlaimmvpoliscrudEvents {
	final String recordId;
	const KlaimmvpoliscrudHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class KlaimmvpoliscrudLihatEvent extends KlaimmvpoliscrudEvents {
	final String recordId;
	const KlaimmvpoliscrudLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMInsurerChangedEvent extends KlaimmvpoliscrudEvents{
	final ComboMInsurerModel comboMInsurer;
	const ComboMInsurerChangedEvent({required this.comboMInsurer});

	@override	List<Object> get props => [comboMInsurer];
}

class ComboMMvjnscoverChangedEvent extends KlaimmvpoliscrudEvents{
	final ComboMMvjnscoverModel comboMMvjnscover;
	const ComboMMvjnscoverChangedEvent({required this.comboMMvjnscover});

	@override	List<Object> get props => [comboMMvjnscover];
}

class FieldInsuredNamaChangedEvent extends KlaimmvpoliscrudEvents{
  final String insuredNama;
  const FieldInsuredNamaChangedEvent({required this.insuredNama});

  @override	List<Object> get props => [insuredNama];
}

class FieldLaporAsuransiChangedEvent extends KlaimmvpoliscrudEvents{
  final DateTime laporAsuransi;
  const FieldLaporAsuransiChangedEvent({required this.laporAsuransi});

  @override	List<Object> get props => [laporAsuransi];
}

class FieldNoChasisChangedEvent extends KlaimmvpoliscrudEvents{
  final String noChasis;
  const FieldNoChasisChangedEvent({required this.noChasis});

  @override	List<Object> get props => [noChasis];
}

class FieldNoPlatChangedEvent extends KlaimmvpoliscrudEvents{
  final String noPlat;
  const FieldNoPlatChangedEvent({required this.noPlat});

  @override	List<Object> get props => [noPlat];
}

class FieldPolisNoChangedEvent extends KlaimmvpoliscrudEvents{
  final String polisNo;
  const FieldPolisNoChangedEvent({required this.polisNo});

  @override	List<Object> get props => [polisNo];
}

class FieldPolisMulaiChangedEvent extends KlaimmvpoliscrudEvents{
  final DateTime polisMulai;
  const FieldPolisMulaiChangedEvent({required this.polisMulai});

  @override	List<Object> get props => [polisMulai];
}

class FieldPolisAkhirChangedEvent extends KlaimmvpoliscrudEvents{
  final DateTime polisAkhir;
  const FieldPolisAkhirChangedEvent({required this.polisAkhir});

  @override	List<Object> get props => [polisAkhir];
}

class KlaimmvPolisAutoSaveEvent extends KlaimmvpoliscrudEvents {} 