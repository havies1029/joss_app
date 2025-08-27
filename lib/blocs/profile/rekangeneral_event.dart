part of 'rekangeneral_bloc.dart';

abstract class RekanGeneralEvents extends Equatable {
	const RekanGeneralEvents();

	@override
	List<Object> get props => [];
}

class RekanGeneralTambahEvent extends RekanGeneralEvents {
	final RekanGeneralModel record;
	const RekanGeneralTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class RekanGeneralUbahEvent extends RekanGeneralEvents {
	final RekanGeneralModel record;
	const RekanGeneralUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class RekanGeneralHapusEvent extends RekanGeneralEvents {
	final String recordId;
	const RekanGeneralHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class RekanGeneralLihatEvent extends RekanGeneralEvents {
	final String recordId;
	const RekanGeneralLihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class ComboMTitleChangedEvent extends RekanGeneralEvents{
	final ComboMTitleModel comboMTitle;
	const ComboMTitleChangedEvent({required this.comboMTitle});

	@override	List<Object> get props => [comboMTitle];}

class ComboMTipeCstChangedEvent extends RekanGeneralEvents{
	final ComboMTipeCstModel comboMTipeCst;
	const ComboMTipeCstChangedEvent({required this.comboMTipeCst});

	@override	List<Object> get props => [comboMTipeCst];}

class ComboMBentukCstChangedEvent extends RekanGeneralEvents{
	final ComboMBentukCstModel comboMBentukCst;
	const ComboMBentukCstChangedEvent({required this.comboMBentukCst});

	@override	List<Object> get props => [comboMBentukCst];}

class ComboMBidangChangedEvent extends RekanGeneralEvents{
	final ComboMBidangModel comboMBidang;
	const ComboMBidangChangedEvent({required this.comboMBidang});

	@override	List<Object> get props => [comboMBidang];}

