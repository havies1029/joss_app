import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_review/reviewcrud_model.dart';
import 'package:joss_app/repositories/gen_review/reviewcrud_repository.dart';

part 'reviewcrud_event.dart';
part 'reviewcrud_state.dart';

class ReviewCrudBloc extends Bloc<ReviewCrudEvent, ReviewCrudState> {
  ReviewCrudBloc() : super(const ReviewCrudState()) {
    on<FetchReviewCrudEvent>(onFetchReviewCrud);
  }

  Future<void> onFetchReviewCrud(
      FetchReviewCrudEvent event,
      Emitter<ReviewCrudState> emit,
      ) async {
    emit(state.copyWith(status: ListStatus.loadingMore));

    try {
      final repo = ReviewCrudRepository();

      final item = await repo.getReviewCrud();

      emit(state.copyWith(
        status: ListStatus.success,
        item: item,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ListStatus.failure,
        message: e.toString(),
      ));
    }
  }
}