part of 'regpar4form_bloc.dart';

class Regpar4FormState extends Equatable {

	final Regpar4FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboRMatauangModel? comboRMatauang;
	const Regpar4FormState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboRMatauang,
});

  static const _sentinel = Object();

	Regpar4FormState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboRMatauang = _sentinel,
	}){
		return Regpar4FormState(
			record: identical(record, _sentinel) ? this.record : record as Regpar4FormModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboRMatauang: identical(comboRMatauang, _sentinel) ? this.comboRMatauang : comboRMatauang as ComboRMatauangModel?,
		);
	}

	@override
	List<Object?> get props => [record ?? '', isLoading, isLoaded, isSaving, isSaved, hasFailure, comboRMatauang ?? ''];
}
