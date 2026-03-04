part of 'rekangeneral_bloc.dart';

class RekanGeneralState extends Equatable {

	final RekanGeneralModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMTitleModel? comboMTitle;
	final ComboMTipeCstModel? comboMTipeCst;
	final ComboMBentukCstModel? comboMBentukCst;
	final ComboMBidangModel? comboMBidang;
	final ComboMJnskelModel? comboMJnskel;
	const RekanGeneralState(
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
		this.comboMJnskel,
});

	RekanGeneralState copyWith({
		RekanGeneralModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboMTitleModel? comboMTitle,
		ComboMTipeCstModel? comboMTipeCst,
		ComboMBentukCstModel? comboMBentukCst,
		ComboMBidangModel? comboMBidang,
		ComboMJnskelModel? comboMJnskel,
	}){
		return RekanGeneralState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMTitle: comboMTitle?? this.comboMTitle,
			comboMTipeCst: comboMTipeCst?? this.comboMTipeCst,
			comboMBentukCst: comboMBentukCst?? this.comboMBentukCst,
			comboMBidang: comboMBidang?? this.comboMBidang,
			comboMJnskel: comboMJnskel?? this.comboMJnskel,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
