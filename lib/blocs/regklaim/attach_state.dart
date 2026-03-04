part of 'attach_bloc.dart';

class AttachState extends Equatable {
  final List<AttachmentItem> items;
  final String? toast;

  const AttachState({
    this.items = const [],
    this.toast,
  });

  AttachState copyWith({
    List<AttachmentItem>? items,
    String? toast,
    bool clearToast = false,
  }) {
    return AttachState(items: items ?? this.items,toast: clearToast ? null : (toast ?? this.toast),);
  }

  @override
  List<Object?> get props => [items, toast];
}
