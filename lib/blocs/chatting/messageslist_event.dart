part of 'messageslist_bloc.dart';

abstract class MessagesListEvents extends Equatable {
	const MessagesListEvents();

	@override
	List<Object> get props => [];
}

class FetchMessagesListEvent extends MessagesListEvents {}

class RefreshMessagesListEvent extends MessagesListEvents {
	final int hal;
	final String searchText;

	const RefreshMessagesListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahMessagesListEvent extends MessagesListEvents {
	final String recordId;

	const UbahMessagesListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahMessagesListEvent extends MessagesListEvents{}
class HapusMessagesListEvent extends MessagesListEvents{}
class CloseDialogMessagesListEvent extends MessagesListEvents{}
