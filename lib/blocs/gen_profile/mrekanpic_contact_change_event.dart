part of 'mrekanpic_contact_change_bloc.dart';

abstract class MRekanPicContactChangeEvent extends Equatable {
  const MRekanPicContactChangeEvent();

  @override
  List<Object?> get props => [];
}

class MRekanPicContactChangeSendRequested extends MRekanPicContactChangeEvent {
  final String mrekanpicId;
  final int changeTypeId;
  final int verifyViaId;

  const MRekanPicContactChangeSendRequested({
    required this.mrekanpicId,
    required this.changeTypeId,
    required this.verifyViaId,
  });

  @override
  List<Object?> get props => [mrekanpicId, changeTypeId, verifyViaId];
}

class MRekanPicContactChangeValidateRequested
    extends MRekanPicContactChangeEvent {
  final String changeRequestId;
  final String pin;

  const MRekanPicContactChangeValidateRequested({
    this.changeRequestId = '',
    required this.pin,
  });

  @override
  List<Object?> get props => [changeRequestId, pin];
}

class MRekanPicContactChangePrepareRequested
    extends MRekanPicContactChangeEvent {
  final String changeRequestId;
  final String newValue;

  const MRekanPicContactChangePrepareRequested({
    this.changeRequestId = '',
    required this.newValue,
  });

  @override
  List<Object?> get props => [changeRequestId, newValue];
}

class MRekanPicContactChangeClearRequested extends MRekanPicContactChangeEvent {
  const MRekanPicContactChangeClearRequested();
}
