part of 'mstatusrincicari_bloc.dart';

abstract class MstatusrinciCariEvents extends Equatable {
	const MstatusrinciCariEvents();

	@override
	List<Object> get props => [];
}

class FetchMstatusrinciCariEvent extends MstatusrinciCariEvents {}

class RefreshMstatusrinciCariEvent extends MstatusrinciCariEvents {}

class SelectedIdChanged extends MstatusrinciCariEvents {
  final String selectedStatusId;
  const SelectedIdChanged(this.selectedStatusId);
}

class SearchTextChanged extends MstatusrinciCariEvents {
  final String searchText;
  const SearchTextChanged(this.searchText);
}