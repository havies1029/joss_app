part of 'calmv1crud_bloc.dart';

class Calmv1CrudState extends Equatable {

	final Calmv1CrudModel? record;
	final bool isLoading;
	final bool isLoaded;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	final ComboMMvjnscoverModel? comboMMvjnscover;
	final ComboMWilayahModel? comboMWilayah;
	final ComboMMvgrupOjkModel? comboMMvgrupOjk;
	final ComboMMvpakaiModel? comboMMvpakaiModel;
	final ComboRMatauangModel? comboRMatauangModel;
	final bool isComplete;
	final bool isDirty;
	final bool isValid;

	const Calmv1CrudState(
		{this.record,
		this.isLoading = false,
		this.isLoaded = false,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
		this.comboMMvjnscover,
		this.comboMWilayah,
		this.comboMMvgrupOjk,
		this.comboMMvpakaiModel,
		this.comboRMatauangModel,
		this.isComplete = false,
		this.isDirty = false,
		this.isValid = false,
});

  static const _sentinel = Object();

	Calmv1CrudState copyWith({
		Object? record = _sentinel,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		Object? comboMMvjnscover = _sentinel,
		Object? comboMWilayah = _sentinel,
		Object? comboMMvgrupOjk = _sentinel,
		Object? comboMMvpakaiModel = _sentinel,
		Object? comboRMatauangModel = _sentinel,
		bool? isComplete,
		bool? isDirty,
		bool? isValid,
	}){
		return Calmv1CrudState(
			record: identical(record, _sentinel) ? this.record : record as Calmv1CrudModel?,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMMvjnscover: identical(comboMMvjnscover, _sentinel) ? this.comboMMvjnscover : comboMMvjnscover as ComboMMvjnscoverModel?,
			comboMWilayah: identical(comboMWilayah, _sentinel) ? this.comboMWilayah : comboMWilayah as ComboMWilayahModel?,
			comboMMvgrupOjk: identical(comboMMvgrupOjk, _sentinel) ? this.comboMMvgrupOjk : comboMMvgrupOjk as ComboMMvgrupOjkModel?,
			comboMMvpakaiModel: identical(comboMMvpakaiModel, _sentinel) ? this.comboMMvpakaiModel : comboMMvpakaiModel as ComboMMvpakaiModel?,
			comboRMatauangModel: identical(comboRMatauangModel, _sentinel) ? this.comboRMatauangModel : comboRMatauangModel as ComboRMatauangModel?,
			isComplete: isComplete ?? this.isComplete,
			isDirty: isDirty ?? this.isDirty,
			isValid: isValid ?? this.isValid,
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
		isComplete,
		isDirty,
		isValid,
		comboMMvjnscover,
		comboMWilayah,
		comboMMvgrupOjk,
		comboMMvpakaiModel,
		comboRMatauangModel,
	];
}
