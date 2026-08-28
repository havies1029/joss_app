part of 'mdetailstssppacari_bloc.dart';

abstract class MDetailStsSppaCariEvents extends Equatable {
  const MDetailStsSppaCariEvents();

  @override
  List<Object> get props => [];
}

class FetchMDetailStsSppaCariEvent extends MDetailStsSppaCariEvents {}

class RefreshMDetailStsSppaCariEvent extends MDetailStsSppaCariEvents {}

class SelectMDetailStsSppaButton extends MDetailStsSppaCariEvents {
  final String id;

  const SelectMDetailStsSppaButton(this.id);

  @override
  List<Object> get props => [id];
}
