import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/chatting/messagescrud_model.dart';
import 'package:joss_app/repositories/chatting/messagescrud_repository.dart';

part 'messagescrud_event.dart';
part 'messagescrud_state.dart';

class MessagesCrudBloc extends Bloc<MessagesCrudEvents, MessagesCrudState> {
	final MessagesCrudRepository repository;
	MessagesCrudBloc({required this.repository}) : super(const MessagesCrudState()) {
		on<MessagesCrudUbahEvent>(onUbahMessagesCrud);
		on<MessagesCrudTambahEvent>(onTambahMessagesCrud);
		on<MessagesCrudHapusEvent>(onHapusMessagesCrud);
		on<MessagesCrudLihatEvent>(onLihatMessagesCrud);
	}

	Future<void> onTambahMessagesCrud(
		MessagesCrudTambahEvent event, Emitter<MessagesCrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.messagesCrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahMessagesCrud(
		MessagesCrudUbahEvent event, Emitter<MessagesCrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.messagesCrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusMessagesCrud(
		MessagesCrudHapusEvent event, Emitter<MessagesCrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.messagesCrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatMessagesCrud(
		MessagesCrudLihatEvent event, Emitter<MessagesCrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		MessagesCrudModel record = await repository.messagesCrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}