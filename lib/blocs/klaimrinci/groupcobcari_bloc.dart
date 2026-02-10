import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/klaimrinci/groupcobcari_model.dart';
import 'package:joss_app/repositories/klaimrinci/groupcobcari_repository.dart';

part 'groupcobcari_event.dart';
part 'groupcobcari_state.dart';

class GroupcobCariBloc extends Bloc<GroupcobCariEvents, GroupcobCariState> {
	GroupcobCariBloc() : super(const GroupcobCariState()) {
		on<FetchGroupcobCariEvent>(onFetchGroupcobCari);
		on<RefreshGroupcobCariEvent>(onRefreshGroupcobCari);
    on<SelectDetailEvent>(onSelectDetail);
    on<UnselectDetailEvent>(onUnselectDetail);
	}

Future<void> onRefreshGroupcobCari(
		RefreshGroupcobCariEvent event, Emitter<GroupcobCariState> emit) async {
	emit(const GroupcobCariState());
    
  if (event.statusId.isNotEmpty) {
  emit(state.copyWith(
    selectedStatusId: event.statusId,
    searchText: event.searchText,
  ));
	add(FetchGroupcobCariEvent());
  }
}

Future<void> onFetchGroupcobCari(
		FetchGroupcobCariEvent event, Emitter<GroupcobCariState> emit) async {

	GroupcobCariRepository repo = GroupcobCariRepository();
    if (state.status == ListStatus.initial) {
      List<GroupcobCariModel> items = await repo.getGroupcobCari(state.selectedStatusId, state.searchText);
      return emit(state.copyWith(
        items: items,
        status: ListStatus.success,
        ));
    }	
	}

  void onSelectDetail(SelectDetailEvent event, Emitter<GroupcobCariState> emit) {
    final updatedSelectedIds = List<String>.from(state.selectedIds)..add(event.klaim1Id);
    emit(state.copyWith(selectedIds: updatedSelectedIds));
  }

  void onUnselectDetail(UnselectDetailEvent event, Emitter<GroupcobCariState> emit) {
    final updatedSelectedIds = List<String>.from(state.selectedIds)..remove(event.klaim1Id);
    emit(state.copyWith(selectedIds: updatedSelectedIds));
  }

}