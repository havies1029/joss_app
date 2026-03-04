part of 'polissourcecari_bloc.dart';

class PolissourcecariState extends Equatable {

	final ListStatus status;
	final List<PolissourcecariModel> items;
	final bool hasReachedMax;
  final String selectedPolissourceId;
	const PolissourcecariState(
		{this.status = ListStatus.initial,
		this.items = const <PolissourcecariModel>[],
		this.hasReachedMax = false,
    this.selectedPolissourceId = "10",
		});

	const PolissourcecariState.success(List<PolissourcecariModel> items)
			: this(status: ListStatus.success, items: items);

	const PolissourcecariState.failure() : this(status: ListStatus.failure);

	PolissourcecariState copyWith(
		{List<PolissourcecariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? selectedPolissourceId

		}){
		return PolissourcecariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      selectedPolissourceId: selectedPolissourceId ?? this.selectedPolissourceId,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, selectedPolissourceId];
}
