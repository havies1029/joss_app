import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/polis_endors_history/polis_endors_history_model.dart';
import 'package:joss_app/repositories/polis_endors_history/polis_endors_history_repository.dart';

part 'polis_endors_history_event.dart';
part 'polis_endors_history_state.dart';

class PolisEndorsHistoryBloc
    extends Bloc<PolisEndorsHistoryEvent, PolisEndorsHistoryState> {
  static const int _pageSize = 20;

  final PolisEndorsHistoryRepository _repository;

  PolisEndorsHistoryBloc({PolisEndorsHistoryRepository? repository})
      : _repository = repository ?? PolisEndorsHistoryRepository(),
        super(const PolisEndorsHistoryState()) {
    on<RefreshPolisEndorsHistoryEvent>(_onRefresh);
    on<FetchPolisEndorsHistoryEvent>(_onFetch);
  }

  Future<void> _onRefresh(
    RefreshPolisEndorsHistoryEvent event,
    Emitter<PolisEndorsHistoryState> emit,
  ) async {
    final queryKey = _buildQueryKey(
      cob: event.cob,
      polis2Id: event.polis2Id,
      searchText: event.searchText,
    );

    emit(
      PolisEndorsHistoryState(
        cob: event.cob,
        polis2Id: event.polis2Id.trim(),
        searchText: event.searchText.trim(),
        queryKey: queryKey,
      ),
    );

    add(const FetchPolisEndorsHistoryEvent());
  }

  Future<void> _onFetch(
    FetchPolisEndorsHistoryEvent event,
    Emitter<PolisEndorsHistoryState> emit,
  ) async {
    final cob = state.cob;
    if (cob == null || state.polis2Id.isEmpty) return;
    if (state.hasReachedMax || state.isFetching) return;

    final queryKeyAtRequest = state.queryKey;
    final pageAtRequest = state.hal;
    emit(state.copyWith(isFetching: true, errorMessage: ''));

    try {
      final newItems = await _repository.getPolisEndorsHistory(
        cob: cob,
        polis2Id: state.polis2Id,
        searchText: state.searchText,
        hal: pageAtRequest,
      );

      if (state.queryKey != queryKeyAtRequest) return;

      final merged = _mergeUnique(state.items, newItems);
      final totalRows =
          newItems.isNotEmpty ? newItems.first.totalRows : state.totalRows;
      final hasReachedMax = !cob.supportsPagination ||
          newItems.isEmpty ||
          newItems.length < _pageSize ||
          (totalRows > 0 && merged.length >= totalRows);

      emit(
        state.copyWith(
          status: ListStatus.success,
          items: merged,
          totalRows: totalRows,
          hasReachedMax: hasReachedMax,
          isFetching: false,
          hal: cob.supportsPagination ? pageAtRequest + 1 : pageAtRequest,
          errorMessage: '',
        ),
      );
    } catch (error) {
      if (state.queryKey != queryKeyAtRequest) return;

      emit(
        state.copyWith(
          status: ListStatus.failure,
          isFetching: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  String _buildQueryKey({
    required PolisEndorsHistoryCob cob,
    required String polis2Id,
    required String searchText,
  }) {
    return '${cob.name}|${polis2Id.trim()}|${searchText.trim().toLowerCase()}';
  }

  List<PolisEndorsHistoryModel> _mergeUnique(
    List<PolisEndorsHistoryModel> current,
    List<PolisEndorsHistoryModel> incoming,
  ) {
    final result = <PolisEndorsHistoryModel>[];
    final seen = <String>{};

    for (final item in <PolisEndorsHistoryModel>[...current, ...incoming]) {
      final key = item.endors2Id.isNotEmpty
          ? item.endors2Id
          : '${item.endors1Id}|${item.rowNumber}';
      if (seen.add(key)) result.add(item);
    }

    return result;
  }
}
