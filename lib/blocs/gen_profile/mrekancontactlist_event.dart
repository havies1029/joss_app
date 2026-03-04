part of 'mrekancontactlist_bloc.dart';

abstract class MRekanContactListEvents extends Equatable {
	const MRekanContactListEvents();

	@override
	List<Object> get props => [];
}

class FetchMRekanContactListEvent extends MRekanContactListEvents {}

class RefreshMRekanContactListEvent extends MRekanContactListEvents {
	final int hal;
	final String searchText;

	const RefreshMRekanContactListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahMRekanContactListEvent extends MRekanContactListEvents {
	final String recordId;

	const UbahMRekanContactListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahMRekanContactListEvent extends MRekanContactListEvents{}
class HapusMRekanContactListEvent extends MRekanContactListEvents{}
class CloseDialogMRekanContactListEvent extends MRekanContactListEvents{}
