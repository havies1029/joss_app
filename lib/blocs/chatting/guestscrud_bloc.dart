import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/chatting/guestscrud_model.dart';
import 'package:joss_app/repositories/chatting/guestscrud_repository.dart';

part 'guestscrud_event.dart';
part 'guestscrud_state.dart';

class GuestsCrudBloc extends Bloc<GuestsCrudEvents, GuestsCrudState> {
	final GuestsCrudRepository repository;
	GuestsCrudBloc({required this.repository}) : super(const GuestsCrudState()) {
		on<GuestsCrudUbahEvent>(onUbahGuestsCrud);
		on<GuestsCrudTambahEvent>(onTambahGuestsCrud);
		on<GuestsCrudHapusEvent>(onHapusGuestsCrud);
		on<GuestsCrudLihatEvent>(onLihatGuestsCrud);
	}

	Future<void> onTambahGuestsCrud(
		GuestsCrudTambahEvent event, Emitter<GuestsCrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.guestsCrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahGuestsCrud(
		GuestsCrudUbahEvent event, Emitter<GuestsCrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.guestsCrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusGuestsCrud(
		GuestsCrudHapusEvent event, Emitter<GuestsCrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.guestsCrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatGuestsCrud(
		GuestsCrudLihatEvent event, Emitter<GuestsCrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		GuestsCrudModel record = await repository.guestsCrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}