import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_review/reviewcari_model.dart';
import 'package:joss_app/repositories/gen_review/reviewcari_repository.dart';

part 'reviewcari_event.dart';
part 'reviewcari_state.dart';

class ReviewCariBloc extends Bloc<ReviewCariEvents, ReviewCariState> {
	ReviewCariBloc() : super(const ReviewCariState()) {
		on<FetchReviewCariEvent>(onFetchReviewCari);
		on<RefreshReviewCariEvent>(onRefreshReviewCari);
	}

Future<void> onRefreshReviewCari(
		RefreshReviewCariEvent event, Emitter<ReviewCariState> emit) async {
	emit(const ReviewCariState());

  emit(state.copyWith(
    hal: 0,
  ));

	add(FetchReviewCariEvent());
}

Future<void> onFetchReviewCari(
		FetchReviewCariEvent event, Emitter<ReviewCariState> emit) async {
	if (state.hasReachedMax) return;

	ReviewCariRepository repo = ReviewCariRepository();
	if (state.status == ListStatus.initial) {
		List<ReviewCariModel> items = await repo.getReviewCari(state.hal);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: 1
			));
	}
	List<ReviewCariModel> items = await repo.getReviewCari(state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<ReviewCariModel> reviewCari = List.of(state.items)..addAll(items);

		final result = reviewCari
			.whereWithIndex((e, index) =>
				reviewCari.indexWhere((e2) => e2.review1Id == e.review1Id) ==
				index)
			.toList();

		return emit(state.copyWith(
			items: result,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: state.hal + 1
			));
		}

	}
}