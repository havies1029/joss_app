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
});

	Calmv1CrudState copyWith({
		Calmv1CrudModel? record,
		bool? isLoading,
		bool? isLoaded,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
		ComboMMvjnscoverModel? comboMMvjnscover,
		ComboMWilayahModel? comboMWilayah,
		ComboMMvgrupOjkModel? comboMMvgrupOjk,
	}){
		return Calmv1CrudState(
			record: record ?? this.record,
			isLoading: isLoading ?? this.isLoading,
			isLoaded: isLoaded ?? this.isLoaded,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
			comboMMvjnscover: comboMMvjnscover?? this.comboMMvjnscover,
			comboMWilayah: comboMWilayah?? this.comboMWilayah,
			comboMMvgrupOjk: comboMMvgrupOjk?? this.comboMMvgrupOjk,
		);
	}

	@override
	List<Object> get props => [isLoading, isLoaded, isSaving, isSaved, hasFailure];
}
