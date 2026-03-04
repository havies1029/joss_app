part of 'mrekangeneral_bloc.dart';

abstract class MRekanGeneralEvents extends Equatable {
	const MRekanGeneralEvents();

	@override
	List<Object> get props => [];
}

class MRekanGeneralTambahEvent extends MRekanGeneralEvents {
	final MRekanGeneralModel record;
	const MRekanGeneralTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class MRekanGeneralUbahEvent extends MRekanGeneralEvents {
	final MRekanGeneralModel record;
	const MRekanGeneralUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class MRekanGeneralHapusEvent extends MRekanGeneralEvents {
	final String recordId;
	const MRekanGeneralHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class MRekanGeneralLihatEvent extends MRekanGeneralEvents {
	final String recordId;
	const MRekanGeneralLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMTitleChangedEvent extends MRekanGeneralEvents{
	final ComboMTitleModel comboMTitle;
	const ComboMTitleChangedEvent({required this.comboMTitle});

	@override	List<Object> get props => [comboMTitle];}

class ComboMTipeCstChangedEvent extends MRekanGeneralEvents{
	final ComboMTipeCstModel comboMTipeCst;
	const ComboMTipeCstChangedEvent({required this.comboMTipeCst});

	@override	List<Object> get props => [comboMTipeCst];}

class ComboMBentukCstChangedEvent extends MRekanGeneralEvents{
	final ComboMBentukCstModel comboMBentukCst;
	const ComboMBentukCstChangedEvent({required this.comboMBentukCst});

	@override	List<Object> get props => [comboMBentukCst];}

class ComboMBidangChangedEvent extends MRekanGeneralEvents{
	final ComboMBidangModel comboMBidang;
	const ComboMBidangChangedEvent({required this.comboMBidang});

	@override	List<Object> get props => [comboMBidang];}

