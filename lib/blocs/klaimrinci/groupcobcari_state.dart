part of 'groupcobcari_bloc.dart';

class GroupcobCariState extends Equatable {

	final ListStatus status;
	final List<GroupcobCariModel> items;
  final String selectedStatusId;
  final String searchText;
  final List<String> selectedIds;
  final String selectedId;
	final KlaimdetailCariModel? selectedKlaimRecord;

	const GroupcobCariState(
		{this.status = ListStatus.initial,
		this.items = const <GroupcobCariModel>[],
    this.selectedStatusId = '',
    this.searchText = '', 
    this.selectedIds = const [],
			this.selectedId = '',
			this.selectedKlaimRecord,
		});

	const GroupcobCariState.success(List<GroupcobCariModel> items)
			: this(status: ListStatus.success, items: items);

	const GroupcobCariState.failure() : this(status: ListStatus.failure);

	GroupcobCariState copyWith(
		{List<GroupcobCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
    String? selectedStatusId,
    String? searchText,
    List<String>? selectedIds,
    String? selectedId,
			KlaimdetailCariModel? selectedKlaimRecord,
		}){
		return GroupcobCariState(
			items: items ?? this.items,
			status: status ?? this.status,
      selectedStatusId: selectedStatusId ?? this.selectedStatusId,
      searchText: searchText ?? this.searchText,
      selectedIds: selectedIds ?? this.selectedIds,
      selectedId: selectedId ?? this.selectedId,
			selectedKlaimRecord: selectedKlaimRecord ?? this.selectedKlaimRecord,
			);
	}

	@override
	List<Object> get props => [status, items, selectedStatusId, searchText, selectedIds, selectedId, selectedKlaimRecord ?? ''];
}
