part of 'regmv2form_bloc.dart';

class Regmv2FormState extends Equatable {

	final Regmv2FormModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMMvjnscoverModel? comboMMvjnscover;
	final ComboRMatauangModel? comboRMatauang;
	const Regmv2FormState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMMvjnscover,
		this.comboRMatauang,
});

  static const _sentinel = Object();

	Regmv2FormState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMMvjnscover = _sentinel,
		Object? comboRMatauang = _sentinel,
	}){
		return Regmv2FormState(
			record: identical(record, _sentinel) ? this.record : record as Regmv2FormModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMMvjnscover: identical(comboMMvjnscover, _sentinel) ? this.comboMMvjnscover : comboMMvjnscover as ComboMMvjnscoverModel?,
			comboRMatauang: identical(comboRMatauang, _sentinel) ? this.comboRMatauang : comboRMatauang as ComboRMatauangModel?,
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
		comboMMvjnscover,
		comboRMatauang,
	];
}
