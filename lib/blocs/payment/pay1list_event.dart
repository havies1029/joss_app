part of 'pay1list_bloc.dart';

abstract class Pay1ListEvents extends Equatable {
	const Pay1ListEvents();

	@override
	List<Object> get props => [];
}

class FetchPay1ListEvent extends Pay1ListEvents {}

class RefreshPay1ListEvent extends Pay1ListEvents {
	final int hal;
	final String searchText;

	const RefreshPay1ListEvent({required this.hal, required this.searchText});

	@override
	List<Object> get props => [hal, searchText];
}

class UbahPay1ListEvent extends Pay1ListEvents {
	final String recordId;

	const UbahPay1ListEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class TambahPay1ListEvent extends Pay1ListEvents{}
class HapusPay1ListEvent extends Pay1ListEvents{}
class CloseDialogPay1ListEvent extends Pay1ListEvents{}
