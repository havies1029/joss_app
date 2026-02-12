part of 'onboardmenucari_bloc.dart';

abstract class OnBoardMenuCariEvents extends Equatable {
  const OnBoardMenuCariEvents();

  @override
  List<Object> get props => [];
}

class LoadOnBoardMenuCariEvent extends OnBoardMenuCariEvents {}

class SetHasPassedBriefingPageEvent extends OnBoardMenuCariEvents {
  final bool hasPassedBriefing;

  const SetHasPassedBriefingPageEvent({required this.hasPassedBriefing});

  @override
  List<Object> get props => [hasPassedBriefing];
}