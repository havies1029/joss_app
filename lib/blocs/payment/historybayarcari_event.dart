part of 'historybayarcari_bloc.dart';

abstract class HistorybayarCariEvents extends Equatable {
	const HistorybayarCariEvents();

	@override
	List<Object> get props => [];
}

class FetchHistorybayarCariEvent extends HistorybayarCariEvents {}

class RefreshHistorybayarCariEvent extends HistorybayarCariEvents {
  final String statusId;
  final String searchText;  
  const RefreshHistorybayarCariEvent({required this.statusId, required this.searchText});
  @override
  List<Object> get props => [statusId, searchText];
}

class SelectHistorybayarCariEvent extends HistorybayarCariEvents {
  final HistorybayarCariModel selected;
  const SelectHistorybayarCariEvent({required this.selected});
}

class DownloadInvoiceEvent extends HistorybayarCariEvents {
  final String noInv;
  const DownloadInvoiceEvent({required this.noInv});
  @override
  List<Object> get props => [noInv];
}