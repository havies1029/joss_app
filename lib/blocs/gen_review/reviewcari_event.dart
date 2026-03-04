part of 'reviewcari_bloc.dart';

abstract class ReviewCariEvents extends Equatable {
	const ReviewCariEvents();

	@override
	List<Object> get props => [];
}

class FetchReviewCariEvent extends ReviewCariEvents {}

class RefreshReviewCariEvent extends ReviewCariEvents {
  final int hal;

  const RefreshReviewCariEvent({this.hal = 0});

  @override
  List<Object> get props => [hal];
}

