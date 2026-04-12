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

  static const _sentinel = Object();

	KlaimringkasCariState copyWith(
		{Object? items = _sentinel,
		ListStatus? status,
    String? selectedStatusId}) {
		return KlaimringkasCariState(
			items: identical(items, _sentinel) ? this.items : items as List<KlaimringkasCariModel>,
			status: status ?? this.status,
      selectedStatusId: selectedStatusId ?? this.selectedStatusId,
    );
	}

	@override
	List<Object?> get props => [status, items, selectedStatusId];
}
