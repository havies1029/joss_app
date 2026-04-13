part of 'klaimringkascari_bloc.dart';

class KlaimringkasCariState extends Equatable {

	final ListStatus status;
	final List<KlaimringkasCariModel> items;
  final String selectedStatusId;

	const KlaimringkasCariState(
		{this.status = ListStatus.initial,
		this.items = const <KlaimringkasCariModel>[],
    this.selectedStatusId = ''});

	const KlaimringkasCariState.success(List<KlaimringkasCariModel> items)
			: this(status: ListStatus.success, items: items);

	const KlaimringkasCariState.failure() : this(status: ListStatus.failure);

	KlaimringkasCariState copyWith(
		{List<KlaimringkasCariModel>? items,
		ListStatus? status,
    String? selectedStatusId}) {
		return KlaimringkasCariState(
			items: items ?? this.items,
			status: status ?? this.status,
      selectedStatusId: selectedStatusId ?? this.selectedStatusId,
    );
	}

	@override
	List<Object?> get props => [status, items, selectedStatusId];
}
