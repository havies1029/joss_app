part of 'chatgroupcari_bloc.dart';

class ChatGroupCariState extends Equatable {
  final ListStatus status;
  final List<types.Message> items;
  final bool hasReachedMax;
  final int hal;
  final DateTime lastFetch;

  const ChatGroupCariState(
      {this.status = ListStatus.initial,
      this.items = const <types.Message>[],
      this.hasReachedMax = false,
      this.hal = 0,
      this.lastFetch = const ConstDateTime(2024, 04, 13, 12, 34, 56, 789, 10)});

  const ChatGroupCariState.success(List<types.Message> items)
      : this(status: ListStatus.success, items: items);

  const ChatGroupCariState.failure() : this(status: ListStatus.failure);

  ChatGroupCariState copyWith(
      {List<types.Message>? items,
      bool? hasReachedMax,
      ListStatus? status,
      int? hal,
      DateTime? lastFetch}) {
    return ChatGroupCariState(
        items: items ?? this.items,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        status: status ?? this.status,
        hal: hal ?? this.hal,
        lastFetch: lastFetch ?? this.lastFetch);
  }

  @override
  List<Object> get props => [status, items, hasReachedMax, hal, lastFetch];
}
