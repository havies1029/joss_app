part of 'mrekanbanklist_bloc.dart';

abstract class MRekanBankListEvents extends Equatable {
	const MRekanBankListEvents();

	@override
	List<Object> get props => [];
}

class FetchMRekanBankListEvent extends MRekanBankListEvents {}

class RefreshMRekanBankListEvent extends MRekanBankListEvents {
	final int hal;
	final String searchText;

	const RefreshMRekanBankListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahMRekanBankListEvent extends MRekanBankListEvents {
	final String recordId;

	const UbahMRekanBankListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahMRekanBankListEvent extends MRekanBankListEvents{}
class HapusMRekanBankListEvent extends MRekanBankListEvents{}
class CloseDialogMRekanBankListEvent extends MRekanBankListEvents{}
