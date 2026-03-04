part of 'mstatusringkascari_bloc.dart';

abstract class MstatusringkasCariEvents extends Equatable {
	const MstatusringkasCariEvents();

	@override
	List<Object> get props => [];
}

class SelectedIdChanged extends MstatusringkasCariEvents {
  final String selectedId;
  const SelectedIdChanged(this.selectedId);

  @override
  List<Object> get props => [selectedId];
}