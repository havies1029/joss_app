part of 'mrekan1crud_bloc.dart';

abstract class MRekan1CrudEvents extends Equatable {
	const MRekan1CrudEvents();

	@override
	List<Object> get props => [];
}

class MRekan1CrudLihatEvent extends MRekan1CrudEvents {}

class MRekan1CrudSetujuTCEvent extends MRekan1CrudEvents {
  final String mrekanId;

  const MRekan1CrudSetujuTCEvent({required this.mrekanId});

  @override
  List<Object> get props => [mrekanId];
}

class SetDataGroup1 extends MRekan1CrudEvents {
  final MRekan1CrudModel record;

  const SetDataGroup1({required this.record});

  @override
  List<Object> get props => [record];
}

class MRekan1CrudReloadEvent extends MRekan1CrudEvents {}
