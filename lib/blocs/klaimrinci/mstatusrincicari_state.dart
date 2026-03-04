part of 'mstatusrincicari_bloc.dart';

class MstatusrinciCariState extends Equatable {

	final ListStatus status;
	final List<MstatusrinciCariModel> items;
	final bool hasReachedMax;
  final String selectedStatusId;
  final String searchText;
	const MstatusrinciCariState(
		{this.status = ListStatus.initial,
		this.items = const <MstatusrinciCariModel>[],
		this.hasReachedMax = false,
    this.selectedStatusId = '',
    this.searchText = '',
		});

	const MstatusrinciCariState.success(List<MstatusrinciCariModel> items)
			: this(status: ListStatus.success, items: items);

	const MstatusrinciCariState.failure() : this(status: ListStatus.failure);

	MstatusrinciCariState copyWith(
		{List<MstatusrinciCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? selectedStatusId,
    String? searchText
		}){
		return MstatusrinciCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
      selectedStatusId: selectedStatusId ?? this.selectedStatusId,
      searchText: searchText ?? this.searchText,
			);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, selectedStatusId, searchText];
}
