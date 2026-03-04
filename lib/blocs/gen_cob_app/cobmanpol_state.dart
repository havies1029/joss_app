part of 'cobmanpol_bloc.dart';

class CobManPolState extends Equatable {

	final ListStatus status;
	final List<CobCariModel> items;
	final bool hasReachedMax;
  final String selectedCOBId;
	const CobManPolState(
		{this.status = ListStatus.initial,
		this.items = const <CobCariModel>[],
		this.hasReachedMax = false,
		this.selectedCOBId = '',
		});

	const CobManPolState.success(List<CobCariModel> items)
			: this(status: ListStatus.success, items: items);

	const CobManPolState.failure() : this(status: ListStatus.failure);

	CobManPolState copyWith(
		{List<CobCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		String? selectedCOBId,
		}){
		return CobManPolState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			selectedCOBId: selectedCOBId ?? this.selectedCOBId,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, selectedCOBId];
}
