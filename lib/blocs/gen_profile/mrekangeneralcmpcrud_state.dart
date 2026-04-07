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
	final bool isDataComplete;
	final bool hasInitializedOnce;

	const MRekanGeneralCmpCrudState({
		this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMBentukCst,
		this.comboMBidang,
		this.isDataComplete = false,
		this.hasInitializedOnce = false,
	});

	static const _unset = Object();

	MRekanGeneralCmpCrudState copyWith({
		Object? record = _unset,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMBentukCst = _unset,
		Object? comboMBidang = _unset,
		bool? isDataComplete,
		bool? hasInitializedOnce,
	}) {
		return MRekanGeneralCmpCrudState(
			record: record == _unset ? this.record : record as MRekanGeneralCmpCrudModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMBentukCst: comboMBentukCst == _unset
					? this.comboMBentukCst
					: comboMBentukCst as ComboMBentukCstModel?,
			comboMBidang: comboMBidang == _unset
					? this.comboMBidang
					: comboMBidang as ComboMBidangModel?,
			isDataComplete: isDataComplete ?? this.isDataComplete,
				hasInitializedOnce: hasInitializedOnce ?? this.hasInitializedOnce,
		);
	}

	@override
	List<Object?> get props => [
		record,
		isLoading,
		isLoaded,
		isSaving,
		isSaved,
		hasFailure,
		comboMBentukCst,
		comboMBidang,
		isDataComplete,
		hasInitializedOnce,
	];
}