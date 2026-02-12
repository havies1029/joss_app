part of 'onboardmenucari_bloc.dart';

class OnBoardMenuCariState extends Equatable {
  final ListStatus status;
  final OnBoardMenuCariModel? item;
  final bool hasPassedBriefing;
  const OnBoardMenuCariState({
    this.status = ListStatus.initial,
    this.item, this.hasPassedBriefing = true
  });

  const OnBoardMenuCariState.success(OnBoardMenuCariModel item)
      : this(status: ListStatus.success, item: item);

  const OnBoardMenuCariState.failure() : this(status: ListStatus.failure);

  OnBoardMenuCariState copyWith({
    OnBoardMenuCariModel? item,
    ListStatus? status,
    bool? hasPassedBriefing
  }) {
    return OnBoardMenuCariState(
      item: item ?? this.item,
      status: status ?? this.status,
      hasPassedBriefing: hasPassedBriefing ?? this.hasPassedBriefing
    );
  }

  @override
  List<Object> get props => [status, hasPassedBriefing];
}
