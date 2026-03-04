part of 'logtrscaritopx_bloc.dart';

abstract class LogtrscaritopxEvents extends Equatable {
	const LogtrscaritopxEvents();

	@override
	List<Object> get props => [];
}

class FetchLogtrscaritopxEvent extends LogtrscaritopxEvents {}

class RefreshLogtrscaritopxEvent extends LogtrscaritopxEvents {}

