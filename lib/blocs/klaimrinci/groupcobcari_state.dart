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

  static const _sentinel = Object();

	GroupcobCariState copyWith(
		{Object? items = _sentinel,
		bool? hasReachedMax,
		ListStatus? status,
    String? selectedStatusId,
    String? searchText,
    List<String>? selectedIds,
    String? selectedId,
		Object? selectedKlaimRecord = _sentinel,
		}){
		return GroupcobCariState(
			items: identical(items, _sentinel) ? this.items : items as List<GroupcobCariModel>,
			status: status ?? this.status,
      selectedStatusId: selectedStatusId ?? this.selectedStatusId,
      searchText: searchText ?? this.searchText,
      selectedIds: selectedIds ?? this.selectedIds,
      selectedId: selectedId ?? this.selectedId,
			selectedKlaimRecord: identical(selectedKlaimRecord, _sentinel) ? this.selectedKlaimRecord : selectedKlaimRecord as KlaimdetailCariModel?,
			);
	}

	@override
	List<Object?> get props => [status, items, selectedStatusId, searchText, selectedIds, selectedId, selectedKlaimRecord];
}
