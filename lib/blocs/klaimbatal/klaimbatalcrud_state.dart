part of 'klaimbatalcrud_bloc.dart';

class KlaimbatalcrudState extends Equatable {

	final KlaimbatalcrudModel? record;
	final bool isSaving;
	final bool isSaved;
	final bool hasFailure;
	const KlaimbatalcrudState(
		{this.record,
		this.isSaving = false,
		this.isSaved = false,
		this.hasFailure = false,
});

	KlaimbatalcrudState copyWith({
		KlaimbatalcrudModel? record,
		bool? isSaving,
		bool? isSaved,
		bool? hasFailure,
	}){
		return KlaimbatalcrudState(
			record: record ?? this.record,
			isSaving: isSaving ?? this.isSaving,
			isSaved: isSaved ?? this.isSaved,
			hasFailure: hasFailure ?? this.hasFailure,
		);
	}

	@override
	List<Object> get props => [isSaving, isSaved, hasFailure];
}
