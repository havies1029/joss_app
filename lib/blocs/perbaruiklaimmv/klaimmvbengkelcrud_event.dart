part of 'klaimmvbengkelcrud_bloc.dart';

abstract class KlaimmvbengkelcrudEvents extends Equatable {
  const KlaimmvbengkelcrudEvents();

  @override
  List<Object?> get props => [];
}

class KlaimmvbengkelcrudTambahEvent extends KlaimmvbengkelcrudEvents {
  final KlaimmvbengkelcrudModel record;
  const KlaimmvbengkelcrudTambahEvent({required this.record});

  @override
  List<Object> get props => [record];
}

class KlaimmvbengkelcrudUbahEvent extends KlaimmvbengkelcrudEvents {
  final KlaimmvbengkelcrudModel record;
  const KlaimmvbengkelcrudUbahEvent({required this.record});

  @override
  List<Object> get props => [record];
}

class KlaimmvbengkelcrudHapusEvent extends KlaimmvbengkelcrudEvents {
  final String recordId;
  const KlaimmvbengkelcrudHapusEvent({required this.recordId});

  @override
  List<Object> get props => [recordId];
}

class KlaimmvbengkelcrudLihatEvent extends KlaimmvbengkelcrudEvents {
  final String recordId;
  const KlaimmvbengkelcrudLihatEvent({required this.recordId});

  @override
  List<Object> get props => [recordId];
}

class ComboMJnsbengkelChangedEvent extends KlaimmvbengkelcrudEvents {
  final ComboMJnsbengkelModel? comboMJnsbengkel;
  const ComboMJnsbengkelChangedEvent({required this.comboMJnsbengkel});

  @override
  List<Object?> get props => [comboMJnsbengkel];
}

class ComboMWilayahBengkelChangedEvent extends KlaimmvbengkelcrudEvents {
  final ComboMWilayahBengkelModel? comboMWilayahBengkel;
  const ComboMWilayahBengkelChangedEvent({required this.comboMWilayahBengkel});

  @override
  List<Object?> get props => [comboMWilayahBengkel];
}

class ComboMBengkelChangedEvent extends KlaimmvbengkelcrudEvents {
  final ComboMBengkelModel comboMBengkel;
  const ComboMBengkelChangedEvent({required this.comboMBengkel});

  @override
  List<Object> get props => [comboMBengkel];
}

class KlaimmvbengkelAutoSaveEvent extends KlaimmvbengkelcrudEvents {
  final String saveFrom;
  const KlaimmvbengkelAutoSaveEvent({required this.saveFrom});

  @override
  List<Object> get props => [saveFrom];
}

class FieldNamaBengkelLainChangedEvent extends KlaimmvbengkelcrudEvents {
  final String namaBengkelLain;
  const FieldNamaBengkelLainChangedEvent({required this.namaBengkelLain});

  @override
  List<Object> get props => [namaBengkelLain];
}
