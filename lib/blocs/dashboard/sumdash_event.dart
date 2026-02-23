part of 'sumdash_bloc.dart';

abstract class SumdashEvents extends Equatable {
  const SumdashEvents();

  @override
  List<Object> get props => [];
}

class SumdashLihatEvent extends SumdashEvents {}
