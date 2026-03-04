part of 'statusasetcari_bloc.dart';

abstract class StatusAsetCariEvents extends Equatable {
	const StatusAsetCariEvents();

	@override
	List<Object> get props => [];
}

class FetchStatusAsetCariEvent extends StatusAsetCariEvents {}

class RefreshStatusAsetCariEvent extends StatusAsetCariEvents {}

class SelectButton extends StatusAsetCariEvents {
  final String id;

  const SelectButton(this.id);

  @override
  List<Object> get props => [id];
}

