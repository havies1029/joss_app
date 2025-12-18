import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/payment/pay1crud_model.dart';
import 'package:joss_app/repositories/payment/pay1crud_repository.dart';

part 'pay1crud_event.dart';
part 'pay1crud_state.dart';

class Pay1CrudBloc extends Bloc<Pay1CrudEvents, Pay1CrudState> {
	final Pay1CrudRepository repository;
	Pay1CrudBloc({required this.repository}) : super(const Pay1CrudState()) {
		on<Pay1CrudUbahEvent>(onUbahPay1Crud);
		on<Pay1CrudTambahEvent>(onTambahPay1Crud);
		on<Pay1CrudHapusEvent>(onHapusPay1Crud);
		on<Pay1CrudLihatEvent>(onLihatPay1Crud);
	}

	Future<void> onTambahPay1Crud(
		Pay1CrudTambahEvent event, Emitter<Pay1CrudState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.pay1CrudTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

	Future<void> onUbahPay1Crud(
		Pay1CrudUbahEvent event, Emitter<Pay1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.pay1CrudUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusPay1Crud(
		Pay1CrudHapusEvent event, Emitter<Pay1CrudState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.pay1CrudHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatPay1Crud(
		Pay1CrudLihatEvent event, Emitter<Pay1CrudState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Pay1CrudModel record = await repository.pay1CrudLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

}