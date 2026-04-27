part of 'reviewcrud_bloc.dart';

abstract class ReviewCrudEvent extends Equatable {
  const ReviewCrudEvent();

  @override
  List<Object?> get props => [];
}

class FetchReviewCrudEvent extends ReviewCrudEvent {}