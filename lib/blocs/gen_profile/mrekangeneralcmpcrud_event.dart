part of 'mrekangeneralcmpcrud_bloc.dart';

abstract class MRekanGeneralCmpCrudEvents extends Equatable {
  const MRekanGeneralCmpCrudEvents();

  @override
  List<Object> get props => [];
}

class MRekanGeneralCmpCrudUbahEvent extends MRekanGeneralCmpCrudEvents {
  final MRekanGeneralCmpCrudModel record;
  const MRekanGeneralCmpCrudUbahEvent({required this.record});

  @override
  List<Object> get props => [record];
}

class MRekanGeneralCmpCrudLihatEvent extends MRekanGeneralCmpCrudEvents {}

class ComboMBentukCstChangedEvent extends MRekanGeneralCmpCrudEvents {
  final ComboMBentukCstModel comboMBentukCst;
  const ComboMBentukCstChangedEvent({required this.comboMBentukCst});

  @override
  List<Object> get props => [comboMBentukCst];
}

class ComboMBidangChangedEvent extends MRekanGeneralCmpCrudEvents {
  final ComboMBidangModel comboMBidang;
  const ComboMBidangChangedEvent({required this.comboMBidang});

  @override
  List<Object> get props => [comboMBidang];
}

class MRekanGeneralCmpCrudResetStatusEvent extends MRekanGeneralCmpCrudEvents {}