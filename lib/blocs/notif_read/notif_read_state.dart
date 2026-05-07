part of 'notif_read_bloc.dart';

class NotifReadState extends Equatable {
  final ListStatus status;

  final NotifReadModel? item;

  final bool isMarked;

  final int unreadCount;

  const NotifReadState({
    this.status = ListStatus.initial,
    this.item,
    this.isMarked = false,
    this.unreadCount = 0,
  });

  NotifReadState copyWith({
    ListStatus? status,
    NotifReadModel? item,
    bool? isMarked,
    int? unreadCount,
  }) {
    return NotifReadState(
      status: status ?? this.status,
      item: item ?? this.item,
      isMarked: isMarked ?? this.isMarked,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [
    status,
    item,
    isMarked,
    unreadCount,
  ];
}