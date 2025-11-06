part of 'asethullcari_bloc.dart';

abstract class AsethullCariEvents extends Equatable {
	const AsethullCariEvents();

	@override
	List<Object> get props => [];
}

class FetchAsethullCariEvent extends AsethullCariEvents {}

class RefreshAsethullCariEvent extends AsethullCariEvents {
  final String searchText;
  final String statusId;

  const RefreshAsethullCariEvent({required this.searchText, required this.statusId});
  
	@override
	List<Object> get props => [searchText, statusId];
}

class DebugFetchAsethullCariEvent extends AsethullCariEvents {
	final String searchText;
	final String statusId;

	const DebugFetchAsethullCariEvent({
		required this.searchText,
		required this.statusId,
	});

	@override
	List<Object> get props => [searchText, statusId];
}

