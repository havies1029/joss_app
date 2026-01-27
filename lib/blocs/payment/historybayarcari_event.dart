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
  const RefreshHistorybayarCariEvent({this.statusId = '', this.searchText = ''});
  @override
  List<Object> get props => [statusId, searchText];
}

