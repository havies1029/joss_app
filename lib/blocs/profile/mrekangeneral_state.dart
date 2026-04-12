part of 'mrekangeneral_bloc.dart';

class MRekanGeneralState extends Equatable {

	final MRekanGeneralModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMTitleModel? comboMTitle;
	final ComboMTipeCstModel? comboMTipeCst;
	final ComboMBentukCstModel? comboMBentukCst;
	final ComboMBidangModel? comboMBidang;
	const MRekanGeneralState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMTitle,
		this.comboMTipeCst,
		this.comboMBentukCst,
		this.comboMBidang,
});

  static const _sentinel = Object();

	MRekanGeneralState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMTitle = _sentinel,
		Object? comboMTipeCst = _sentinel,
		Object? comboMBentukCst = _sentinel,
		Object? comboMBidang = _sentinel,
	}){
		return MRekanGeneralState(
			record: identical(record, _sentinel) ? this.record : record as MRekanGeneralModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMTitle: identical(comboMTitle, _sentinel) ? this.comboMTitle : comboMTitle as ComboMTitleModel?,
			comboMTipeCst: identical(comboMTipeCst, _sentinel) ? this.comboMTipeCst : comboMTipeCst as ComboMTipeCstModel?,
			comboMBentukCst: identical(comboMBentukCst, _sentinel) ? this.comboMBentukCst : comboMBentukCst as ComboMBentukCstModel?,
			comboMBidang: identical(comboMBidang, _sentinel) ? this.comboMBidang : comboMBidang as ComboMBidangModel?,
		);
	}

	@override
	List<Object?> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure, record ?? '', comboMTitle ?? '', comboMTipeCst ?? '', comboMBentukCst ?? '', comboMBidang ?? ''];
}
