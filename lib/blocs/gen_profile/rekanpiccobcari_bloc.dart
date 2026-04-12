import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/gen_profile/rekanpiccobcari_model.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/repositories/gen_profile/rekanpiccobcari_repository.dart';

part 'rekanpiccobcari_event.dart';
part 'rekanpiccobcari_state.dart';
class RekanPicCobCariBloc
    extends Bloc<RekanPicCobCariEvents, RekanPicCobCariState> {
  RekanPicCobCariBloc() : super(const RekanPicCobCariState()) {
    on<FetchRekanPicCobCariEvent>(onFetchRekanPicCobCari);
    on<RefreshRekanPicCobCariEvent>(onRefreshRekanPicCobCari);
    on<InitialSelectedCOBRekanPicCobEvent>(onInitialSelectedCOB);
    on<UpdateCheckboxRekanPicCobEvent>(onUpdateCheckboxChanged);
    on<Update2ApiJRekanPicCobEvent>(onUpdate2ApiRekanPicCob);
    on<ResetSelectedCOBRekanPicCobEvent>(onResetSelectedCOB);
  }

  Future<void> onResetSelectedCOB(
      ResetSelectedCOBRekanPicCobEvent event,
      Emitter<RekanPicCobCariState> emit,
      ) async {
    final resetItems = state.items.map((item) {
      item.isChecked = false;
      return item;
    }).toList();

    emit(state.copyWith(
      items: resetItems,
      selectedItems: const <RekanPicCobCariModel>[],
      isSaved: false,
      isSaving: false,
      hasFailure: false,
      requestToUpdate: false,
    ));
  }

  Future<void> onRefreshRekanPicCobCari(
      RefreshRekanPicCobCariEvent event,
      Emitter<RekanPicCobCariState> emit,
      ) async {
    final isDifferentPicId = state.rekanPicId != event.rekanPicId;

    emit(state.copyWith(
      status: ListStatus.initial,
      items: const <RekanPicCobCariModel>[],
      selectedItems:
      isDifferentPicId ? const <RekanPicCobCariModel>[] : state.selectedItems,
      hasReachedMax: false,
      searchText: event.searchText,
      rekanPicId: event.rekanPicId,
      hal: 0,
      isSaved: false,
      isSaving: false,
      hasFailure: false,
      requestToUpdate: false,
      isFetchingMore: false,
    ));

    add(FetchRekanPicCobCariEvent());
  }

  Future<void> onFetchRekanPicCobCari(
      FetchRekanPicCobCariEvent event,
      Emitter<RekanPicCobCariState> emit,
      ) async {
    if (state.hasReachedMax || state.isFetchingMore) return;

    try {
      final repo = RekanPicCobCariRepository();

      emit(state.copyWith(isFetchingMore: true));

      if (state.status == ListStatus.initial) {
        List<RekanPicCobCariModel> fetchedItems =
        await repo.getRekanPicCobCari(
          state.rekanPicId,
          state.searchText,
          0,
        );

        fetchedItems = _syncFetchedItemsWithSelected(
          fetchedItems,
          state.selectedItems,
        );

        final mergedSelected = _mergeSelectedWithFetchedChecked(
          state.selectedItems,
          fetchedItems,
        );

        emit(state.copyWith(
          items: fetchedItems,
          selectedItems: mergedSelected,
          hasReachedMax: fetchedItems.isEmpty,
          status: ListStatus.success,
          hal: fetchedItems.isEmpty ? 0 : 1,
          isFetchingMore: false,
        ));
        return;
      }

      List<RekanPicCobCariModel> fetchedItems =
      await repo.getRekanPicCobCari(
        state.rekanPicId,
        state.searchText,
        state.hal,
      );

      if (fetchedItems.isEmpty) {
        emit(state.copyWith(
          hasReachedMax: true,
          isFetchingMore: false,
        ));
        return;
      }

      fetchedItems = _syncFetchedItemsWithSelected(
        fetchedItems,
        state.selectedItems,
      );

      final mergedItems = List<RekanPicCobCariModel>.from(state.items)
        ..addAll(fetchedItems);

      final uniqueItems = _deduplicateByMcobIdFromItems(mergedItems);

      final mergedSelected = _mergeSelectedWithFetchedChecked(
        state.selectedItems,
        fetchedItems,
      );

      emit(state.copyWith(
        items: uniqueItems,
        selectedItems: mergedSelected,
        hasReachedMax: false,
        status: ListStatus.success,
        hal: state.hal + 1,
        isFetchingMore: false,
      ));
    } catch (e) {
      debugPrint('onFetchRekanPicCobCari error: $e');
      emit(state.copyWith(
        status: ListStatus.failure,
        isFetchingMore: false,
      ));
    }
  }

  Future<void> onInitialSelectedCOB(
      InitialSelectedCOBRekanPicCobEvent event,
      Emitter<RekanPicCobCariState> emit,
      ) async {
    final initialSelected = event.selectedCOB.map((item) {
      item.isChecked = true;
      return item;
    }).toList();

    final syncedItems = _syncFetchedItemsWithSelected(
      List<RekanPicCobCariModel>.from(state.items),
      initialSelected,
    );

    emit(state.copyWith(
      selectedItems: _deduplicateByMcobId(initialSelected),
      items: syncedItems,
    ));
  }

  Future<void> onUpdateCheckboxChanged(
      UpdateCheckboxRekanPicCobEvent event,
      Emitter<RekanPicCobCariState> emit,
      ) async {
    final changedItem = event.rekanPicCobItem;
    changedItem.isChecked = event.isChecked;

    final items = List<RekanPicCobCariModel>.from(state.items);
    final itemIndex =
    items.indexWhere((element) => element.mcobId == changedItem.mcobId);

    if (itemIndex != -1) {
      items[itemIndex] = changedItem;
    }

    final updatedSelectedItems = _updateSelectedItem(
      state.selectedItems,
      changedItem,
    );

    emit(state.copyWith(
      items: items,
      selectedItems: updatedSelectedItems,
      status: ListStatus.success,
      isSaved: false,
      hasFailure: false,
    ));
  }

  Future<void> onUpdate2ApiRekanPicCob(
      Update2ApiJRekanPicCobEvent event,
      Emitter<RekanPicCobCariState> emit,
      ) async {
    debugPrint("onUpdate2ApiRekanPicCob #10");

    emit(state.copyWith(
      isSaving: true,
      isSaved: false,
      hasFailure: false,
      requestToUpdate: false,
    ));

    bool hasFailure = false;

    try {
      if (event.rekanPicId.isNotEmpty) {
        final picCobList = List<RekanPicCobCariModel>.from(state.selectedItems);

        final listCheckbox = List<RekanPicCobCariCheckboxModel>.generate(
          picCobList.length,
              (index) => RekanPicCobCariCheckboxModel(
            mcobId: picCobList[index].mcobId,
            isChecked: picCobList[index].isChecked,
          ),
        )..removeWhere((element) => !element.isChecked);

        if (listCheckbox.isNotEmpty) {
          final repo = RekanPicCobCariRepository();
          final ReturnDataAPI returnApi =
          await repo.rekanPicCobUpdateList(event.rekanPicId, listCheckbox);

          hasFailure = !returnApi.success;
        }
      }
    } catch (e) {
      debugPrint("onUpdate2ApiRekanPicCob error: $e");
      hasFailure = true;
    }

    emit(state.copyWith(
      isSaving: false,
      isSaved: true,
      hasFailure: hasFailure,
    ));
  }

  List<RekanPicCobCariModel> _syncFetchedItemsWithSelected(
      List<RekanPicCobCariModel> fetchedItems,
      List<RekanPicCobCariModel> selectedItems,
      ) {
    if (selectedItems.isEmpty) {
      return fetchedItems;
    }

    final selectedIds = selectedItems.map((e) => e.mcobId).toSet();

    for (final item in fetchedItems) {
      item.isChecked = selectedIds.contains(item.mcobId);
    }

    return fetchedItems;
  }

  List<RekanPicCobCariModel> _mergeSelectedWithFetchedChecked(
      List<RekanPicCobCariModel> oldSelected,
      List<RekanPicCobCariModel> fetchedItems,
      ) {
    final merged = List<RekanPicCobCariModel>.from(oldSelected);

    for (final item in fetchedItems) {
      if (item.isChecked) {
        merged.removeWhere((e) => e.mcobId == item.mcobId);
        merged.add(item);
      }
    }

    return _deduplicateByMcobId(merged);
  }

  List<RekanPicCobCariModel> _updateSelectedItem(
      List<RekanPicCobCariModel> selectedItems,
      RekanPicCobCariModel changedItem,
      ) {
    final result = List<RekanPicCobCariModel>.from(selectedItems);

    result.removeWhere((e) => e.mcobId == changedItem.mcobId);

    if (changedItem.isChecked) {
      result.add(changedItem);
    }

    return _deduplicateByMcobId(result);
  }

  List<RekanPicCobCariModel> _deduplicateByMcobId(
      List<RekanPicCobCariModel> items,
      ) {
    final result = <RekanPicCobCariModel>[];

    for (final item in items) {
      final exists = result.any((e) => e.mcobId == item.mcobId);
      if (!exists) {
        result.add(item);
      }
    }

    return result;
  }

  List<RekanPicCobCariModel> _deduplicateByMcobIdFromItems(
      List<RekanPicCobCariModel> items,
      ) {
    final result = <RekanPicCobCariModel>[];

    for (final item in items) {
      final exists = result.any((e) => e.mcobId == item.mcobId);
      if (!exists) {
        result.add(item);
      }
    }

    return result;
  }
}