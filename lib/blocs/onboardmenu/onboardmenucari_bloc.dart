import 'package:equatable/equatable.dart';
import 'package:joss_app/models/onboardmenu/onboardmenucari_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/repositories/onboardmenu/onboardmenucari_repository.dart';

import '../../common/constants.dart';

part 'onboardmenucari_event.dart';
part 'onboardmenucari_state.dart';

class OnBoardMenuCariBloc
    extends Bloc<OnBoardMenuCariEvents, OnBoardMenuCariState> {
  OnBoardMenuCariBloc() : super(const OnBoardMenuCariState()) {
    on<LoadOnBoardMenuCariEvent>(onLoadMenu);
    on<SetHasPassedBriefingPageEvent>(onSetHasPassBriefing);
  }

  Future<void> onLoadMenu(LoadOnBoardMenuCariEvent event,
      Emitter<OnBoardMenuCariState> emit) async {
    debugPrint("onLoadMenu #10");
    
    emit(state.copyWith(status: ListStatus.initial));

    OnBoardMenuCariRepository repo = OnBoardMenuCariRepository();
    OnBoardMenuCariModel item = await repo.getOnBoardMenuCari();

    debugPrint("onLoadMenu item : ${item.toJson()}");

    emit(state.copyWith(item: item, status: ListStatus.success));
  }

  Future<void> onSetHasPassBriefing(SetHasPassedBriefingPageEvent event,
      Emitter<OnBoardMenuCariState> emit) async {
    emit(state.copyWith(hasPassedBriefing: event.hasPassedBriefing));
  }
}
