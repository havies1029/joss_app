part of 'mstatusringkascari_bloc.dart';

abstract class MstatusringkasCariEvents extends Equatable {
	const MstatusringkasCariEvents();

	@override
	List<Object> get props => [];
}

class FetchMstatusringkasCariEvent extends MstatusringkasCariEvents {}

class RefreshMstatusringkasCariEvent extends MstatusringkasCariEvents {}

class SelectedIdChanged extends MstatusringkasCariEvents {
  final String selectedId;
  const SelectedIdChanged(this.selectedId);
}