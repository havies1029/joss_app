part of 'reguser_bloc.dart';

abstract class RegUserEvents extends Equatable {
  const RegUserEvents();

  @override
  List<Object> get props => [];
}

class RegUserTambahEvent extends RegUserEvents {
  final RegUserModel record;
  final String requestFrom;
  const RegUserTambahEvent({required this.record, required this.requestFrom});

  @override
  List<Object> get props => [record, requestFrom];
}

class RegUserUbahEvent extends RegUserEvents {
  final RegUserModel record;
  const RegUserUbahEvent({required this.record});

  @override
  List<Object> get props => [record];
}

class RegUserHapusEvent extends RegUserEvents {
  final String recordId;
  const RegUserHapusEvent({required this.recordId});

  @override
  List<Object> get props => [recordId];
}

class RegUserLihatEvent extends RegUserEvents {
  final String recordId;
  const RegUserLihatEvent({required this.recordId});

  @override
  List<Object> get props => [recordId];
}

class ValidasiPinHPEvent extends RegUserEvents {
  final RegUserModel record;
  final String sentTo; // email atau hpno
  final String sentVia; // email atau sms
  const ValidasiPinHPEvent(
      {required this.record, required this.sentTo, required this.sentVia});

  @override
  List<Object> get props => [record, sentTo, sentVia];
}

class SetIsEmailEvent extends RegUserEvents {
  final bool isEmail;

  const SetIsEmailEvent({required this.isEmail});

  @override
  List<Object> get props => [isEmail];
}

class ResendOtpEvent extends RegUserEvents {
  final String reguserId;

  const ResendOtpEvent({required this.reguserId});

  @override
  List<Object> get props => [reguserId];
}

class ClearRequestFromEvent extends RegUserEvents {
  const ClearRequestFromEvent();
}

class SetRequestFromEvent extends RegUserEvents {
  final String requestFrom;

  const SetRequestFromEvent(this.requestFrom);

  @override
  List<Object> get props => [requestFrom];
}
