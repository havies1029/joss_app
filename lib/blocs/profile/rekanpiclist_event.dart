part of 'rekanpiclist_bloc.dart';

abstract class RekanPicListEvents extends Equatable {
	const RekanPicListEvents();

	@override
	List<Object> get props => [];
}

class FetchRekanPicListEvent extends RekanPicListEvents {}

class RefreshRekanPicListEvent extends RekanPicListEvents {
	final int hal;
	final String searchText;

	const RefreshRekanPicListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahRekanPicListEvent extends RekanPicListEvents {
	final String recordId;

	const UbahRekanPicListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahRekanPicListEvent extends RekanPicListEvents{}
class HapusRekanPicListEvent extends RekanPicListEvents{}
class CloseDialogRekanPicListEvent extends RekanPicListEvents{}
