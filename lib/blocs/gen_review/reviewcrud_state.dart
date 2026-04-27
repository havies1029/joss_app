part of 'reviewcrud_bloc.dart';

class ReviewCrudState extends Equatable {
  final ListStatus status;
  final ReviewCrudModel? item;
  final String message;

  const ReviewCrudState({
    this.status = ListStatus.initial,
    this.item,
    this.message = '',
  });

  ReviewCrudState copyWith({
    ListStatus? status,
    ReviewCrudModel? item,
    String? message,
  }) {
    return ReviewCrudState(
      status: status ?? this.status,
      item: item ?? this.item,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, item, message];
}