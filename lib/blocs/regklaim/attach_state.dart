part of 'attach_bloc.dart';

class AttachState extends Equatable {
  final List<AttachmentItem> items;

  const AttachState({this.items = const []});

  AttachState copyWith({List<AttachmentItem>? items}) {
    return AttachState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
