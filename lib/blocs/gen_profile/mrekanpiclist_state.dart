part of 'mrekanpiclist_bloc.dart';

class MRekanPicListState extends Equatable {
	final ListStatus status;
	final List<MRekanPicListModel> items;
	final String errorMessage;

	const MRekanPicListState({
		this.status = ListStatus.initial,
		this.items = const <MRekanPicListModel>[],
		this.errorMessage = '',
	});

	MRekanPicListState copyWith({
		ListStatus? status,
		List<MRekanPicListModel>? items,
		String? errorMessage,
	}) {
		return MRekanPicListState(
			status: status ?? this.status,
			items: items ?? this.items,
			errorMessage: errorMessage ?? this.errorMessage,
		);
	}

	@override
	List<Object> get props => [status, items, errorMessage];
}