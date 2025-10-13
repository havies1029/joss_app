import 'dart:convert';

import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_profile/rekanpiccobcari_model.dart';
import 'package:joss_app/repositories/gen_profile/rekanpiccobcari_repository.dart';

part 'rekanpiccobcari_event.dart';
part 'rekanpiccobcari_state.dart';

class RekanPicCobCariBloc extends Bloc<RekanPicCobCariEvents, RekanPicCobCariState> {
	RekanPicCobCariBloc() : super(const RekanPicCobCariState()) {
		on<FetchRekanPicCobCariEvent>(onFetchRekanPicCobCari);
		on<RefreshRekanPicCobCariEvent>(onRefreshRekanPicCobCari);
    on<InitialSelectedCOBRekanPicCobEvent>(onInitialSelectedCOB);
    on<UpdateCheckboxRekanPicCobEvent>(onUpdateCheckboxChanged);
    on<Update2ApiJRekanPicCobEvent>(onUpdate2ApiRekanPicCob);
	}

Future<void> onRefreshRekanPicCobCari(
		RefreshRekanPicCobCariEvent event, Emitter<RekanPicCobCariState> emit) async {
	emit(const RekanPicCobCariState());

  emit(state.copyWith(rekanPicId: event.rekanPicId, searchText: event.searchText));

	add(FetchRekanPicCobCariEvent());
}

Future<void> onFetchRekanPicCobCari(
		FetchRekanPicCobCariEvent event, Emitter<RekanPicCobCariState> emit) async {
	if (state.hasReachedMax) return;

	RekanPicCobCariRepository repo = RekanPicCobCariRepository();
	if (state.status == ListStatus.initial) {
		List<RekanPicCobCariModel> items = await repo.getRekanPicCobCari(state.rekanPicId, state.searchText, 0);
		return emit(state.copyWith(
			items: items,
			hasReachedMax: false,
			status: ListStatus.success,
      hal: 1
			));
	}
	List<RekanPicCobCariModel> items = await repo.getRekanPicCobCari(state.rekanPicId, state.searchText, state.hal);
	if (items.isEmpty) {
		return emit(state.copyWith(hasReachedMax: true));
	} else {
		List<RekanPicCobCariModel> rekanPicCobCari = List.of(state.items)..addAll(items);

		final result = rekanPicCobCari
			.whereWithIndex((e, index) =>
				rekanPicCobCari.indexWhere((e2) => e2.mrekanpiccobId == e.mrekanpiccobId) ==
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

  Future<void> onInitialSelectedCOB(InitialSelectedCOBRekanPicCobEvent event,
      Emitter<RekanPicCobCariState> emit) async {
    ///debugPrint("initialSelectedCOB");

    //debugPrint("event.selectedCOB : ${jsonEncode(event.selectedCOB)}");
    //set item as checked
    for (int i = 0; i < event.selectedCOB.length; i++) {
      event.selectedCOB[i].isChecked = true;
    }

    emit(state.copyWith(selectedItems: event.selectedCOB));

    //debugPrint("state.selectedItems after initialing : ${jsonEncode(state.selectedItems)}");
  }

  Future<void> onUpdateCheckboxChanged(UpdateCheckboxRekanPicCobEvent event,
      Emitter<RekanPicCobCariState> emit) async {
    //emit(state.copyWith(status: ListStatus.initial));

    debugPrint("onUpdateCheckboxChanged #10");

    RekanPicCobCariModel itemCheckbox = event.rekanPicCobItem;
    itemCheckbox.isChecked = event.isChecked;

    List<RekanPicCobCariModel> items = state.items;

    debugPrint("before : items : ${jsonEncode(items)}");

    debugPrint("itemCheckbox.cobNama : ${itemCheckbox.cobNama}");

    items[items.indexWhere(
      (element) => element.mcobId == itemCheckbox.mcobId)] = itemCheckbox;

    List<RekanPicCobCariModel> checked = [itemCheckbox];

    List<RekanPicCobCariModel>? selectedItems =
      await updateSelectedItem(state.selectedItems, checked);
    
    emit(state.copyWith(selectedItems: selectedItems));

    debugPrint("after : state.items : ${jsonEncode(items)}");

    debugPrint("onUpdateCheckboxChanged #20");

    emit(state.copyWith(items: items, status: ListStatus.success));
  }

  Future<List<RekanPicCobCariModel>> updateSelectedItem(
      List<RekanPicCobCariModel> selectedItems,
      List<RekanPicCobCariModel> newItems) async {
    //debugPrint("updateSelectedItem");

    //debugPrint("selectedItems : ${jsonEncode(selectedItems)}");

    List<RekanPicCobCariModel> result = <RekanPicCobCariModel>[];
    result.addAll(selectedItems);

    List<RekanPicCobCariModel> newSelectedItems = newItems
        .where(
          (element) => element.isChecked,
        )
        .toList();

    //debugPrint("new SelectedItems : ${jsonEncode(newSelectedItems)}");
    if (newSelectedItems.isNotEmpty) {
      //debugPrint("newSelectedItems.isNotEmpty : ${newSelectedItems.isNotEmpty}");
      result.addAll(newSelectedItems);
    }

    List<RekanPicCobCariModel> removedItems = newItems
        .where(
          (element) => !element.isChecked,
        )
        .toList();

    if (removedItems.isNotEmpty) {
      for (var element in removedItems) {
        result.removeWhere((e) => e.mcobId == element.mcobId);
      }
    }

    //debugPrint("removedItems : ${jsonEncode(removedItems)}");

    //debugPrint("result selectedItems : ${jsonEncode(result)}");
    //}
    return result;
  }

  Future<void> onUpdate2ApiRekanPicCob(
      Update2ApiJRekanPicCobEvent event, Emitter<RekanPicCobCariState> emit) async {
    debugPrint("onUpdate2ApiRekanPicCob #10");

    emit(state.copyWith(
        isSaving: true,
        isSaved: false,
        hasFailure: false,
        requestToUpdate: false));
    bool hasFailure = false;

    if (event.rekanPicId.isNotEmpty) {
      List<RekanPicCobCariModel> picCobList = state.selectedItems;
      List<RekanPicCobCariCheckboxModel> listCheckbox =
          List<RekanPicCobCariCheckboxModel>.generate(
              picCobList.length,
              (index) => RekanPicCobCariCheckboxModel(
                  mcobId: picCobList[index].mcobId,
                  isChecked: picCobList[index].isChecked));

      listCheckbox.removeWhere((element) => !element.isChecked);
      if (listCheckbox.isNotEmpty) {
        RekanPicCobCariRepository repo = RekanPicCobCariRepository();
        ReturnDataAPI returnApi =
            await repo.rekanPicCobUpdateList(event.rekanPicId, listCheckbox);
        hasFailure = !returnApi.success;
      }
    }

    emit(
        state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

}