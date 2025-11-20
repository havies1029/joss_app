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

	Regmv2FormState copyWith({
		Regmv2FormModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboMMvjnscoverModel? comboMMvjnscover,
		ComboRMatauangModel? comboRMatauang,
	}){
		return Regmv2FormState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMMvjnscover: comboMMvjnscover?? this.comboMMvjnscover,
			comboRMatauang: comboRMatauang?? this.comboRMatauang,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
