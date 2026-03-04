part of 'mrekanpiclist_bloc.dart';

abstract class MRekanPicListEvents extends Equatable {
	const MRekanPicListEvents();

	@override
	List<Object> get props => [];
}

class FetchMRekanPicListEvent extends MRekanPicListEvents {}

class RefreshMRekanPicListEvent extends MRekanPicListEvents {}

class UbahMRekanPicListEvent extends MRekanPicListEvents {
	final String recordId;

	const UbahMRekanPicListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahMRekanPicListEvent extends MRekanPicListEvents{}
class HapusMRekanPicListEvent extends MRekanPicListEvents{}
class CloseDialogMRekanPicListEvent extends MRekanPicListEvents{}
