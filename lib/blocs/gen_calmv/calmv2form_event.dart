part of 'calmv2form_bloc.dart';

abstract class Calmv2FormEvents extends Equatable {
	const Calmv2FormEvents();

	@override
	List<Object> get props => [];
}

class Calmv2FormTambahEvent extends Calmv2FormEvents {
	final Calmv2FormModel record;
	const Calmv2FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calmv2FormUbahEvent extends Calmv2FormEvents {
	final Calmv2FormModel record;
	const Calmv2FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calmv2FormHapusEvent extends Calmv2FormEvents {
	final String recordId;
	const Calmv2FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Calmv2FormLihatEvent extends Calmv2FormEvents {
	final String recordId;
	const Calmv2FormLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Calmv2FormDraftEvent extends Calmv2FormEvents {
	final Calmv2FormModel record;
	const Calmv2FormDraftEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calmv2ResetStatusEvent extends Calmv2FormEvents {
	const Calmv2ResetStatusEvent();
}

class FieldAwChangedEvent extends Calmv2FormEvents {
	final double aw;
	const FieldAwChangedEvent({required this.aw});
	@override
	List<Object> get props => [aw];
}

class FieldPadChangedEvent extends Calmv2FormEvents {
	final double pad;
	const FieldPadChangedEvent({required this.pad});
	@override
	List<Object> get props => [pad];
}

class FieldPapChangedEvent extends Calmv2FormEvents {
	final double pap;
	const FieldPapChangedEvent({required this.pap});
	@override
	List<Object> get props => [pap];
}

class FieldPllChangedEvent extends Calmv2FormEvents {
	final double pll;
	const FieldPllChangedEvent({required this.pll});
	@override
	List<Object> get props => [pll];
}

class FieldTplChangedEvent extends Calmv2FormEvents {
	final double tpl;
	const FieldTplChangedEvent({required this.tpl});
	@override
	List<Object> get props => [tpl];
}

// Boolean flags (checkbox)
class FieldIsEqChangedEvent extends Calmv2FormEvents {
	final bool isEq;
	const FieldIsEqChangedEvent({required this.isEq});
	@override
	List<Object> get props => [isEq];
}

class FieldIsFloodChangedEvent extends Calmv2FormEvents {
	final bool isFlood;
	const FieldIsFloodChangedEvent({required this.isFlood});
	@override
	List<Object> get props => [isFlood];
}

class FieldIsSrccChangedEvent extends Calmv2FormEvents {
	final bool isSrcc;
	const FieldIsSrccChangedEvent({required this.isSrcc});
	@override
	List<Object> get props => [isSrcc];
}

class FieldIsTbodChangedEvent extends Calmv2FormEvents {
	final bool isTbod;
	const FieldIsTbodChangedEvent({required this.isTbod});
	@override
	List<Object> get props => [isTbod];
}

class FieldIsTerrorismChangedEvent extends Calmv2FormEvents {
	final bool isTerrorism;
	const FieldIsTerrorismChangedEvent({required this.isTerrorism});
	@override
	List<Object> get props => [isTerrorism];
}

// PassengerCount (punyamu awalnya string, tapi di model int)
class FieldPassengerCountChangedEvent extends Calmv2FormEvents {
	final int passangerCount;
	const FieldPassengerCountChangedEvent({required this.passangerCount});
	@override
	List<Object> get props => [passangerCount];
}

class FieldCalmv1IdChangedEvent extends Calmv2FormEvents {
	final String calmv1Id;
	const FieldCalmv1IdChangedEvent({required this.calmv1Id});
	@override
	List<Object> get props => [calmv1Id];
}

// (opsional) AutoSave event
class Calmv2AutoSaveEvent extends Calmv2FormEvents {
	const Calmv2AutoSaveEvent();
}