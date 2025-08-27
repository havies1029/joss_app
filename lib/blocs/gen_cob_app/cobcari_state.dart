part of 'cobcari_bloc.dart';

class CobCariState extends Equatable {

	final ListStatus status;
	final List<CobCariModel> items;
	final bool hasReachedMax;
  final String selectedCOBId;
	const CobCariState(
		{this.status = ListStatus.initial,
		this.items = const <CobCariModel>[],
		this.hasReachedMax = false,
		this.selectedCOBId = '',
		});

	const CobCariState.success(List<CobCariModel> items)
			: this(status: ListStatus.success, items: items);

	const CobCariState.failure() : this(status: ListStatus.failure);

	CobCariState copyWith(
		{List<CobCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		String? selectedCOBId,
		}){
		return CobCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			selectedCOBId: selectedCOBId ?? this.selectedCOBId,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, selectedCOBId];
}
