part of 'mrekangeneralcmpcrud_bloc.dart';

class MRekanGeneralCmpCrudState extends Equatable {

	final MRekanGeneralCmpCrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMBentukCstModel? comboMBentukCst;
	final ComboMBidangModel? comboMBidang;
	const MRekanGeneralCmpCrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMBentukCst,
		this.comboMBidang,
});

	MRekanGeneralCmpCrudState copyWith({
		MRekanGeneralCmpCrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboMBentukCstModel? comboMBentukCst,
		ComboMBidangModel? comboMBidang,
	}){
		return MRekanGeneralCmpCrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMBentukCst: comboMBentukCst?? this.comboMBentukCst,
			comboMBidang: comboMBidang?? this.comboMBidang,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
