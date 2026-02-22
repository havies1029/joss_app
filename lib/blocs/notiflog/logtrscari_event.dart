part of 'logtrscari_bloc.dart';

abstract class LogtrscariEvents extends Equatable {
	const LogtrscariEvents();

	@override
	List<Object> get props => [];
}

class FetchLogtrscariEvent extends LogtrscariEvents {}

class RefreshLogtrscariEvent extends LogtrscariEvents {
  final String groupLogId;
  const RefreshLogtrscariEvent({required this.groupLogId});

  @override
  List<Object> get props => [groupLogId];
}

