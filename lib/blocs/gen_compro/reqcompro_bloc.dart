import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/gen_compro/reqcompro_model.dart';
import 'package:joss_app/repositories/gen_compro/reqcompro_repository.dart';

part 'reqcompro_event.dart';
part 'reqcompro_state.dart';

class ReqComproBloc extends Bloc<ReqComproEvents, ReqComproState> {
	final ReqComproRepository repository;
	ReqComproBloc({required this.repository}) : super(const ReqComproState()) {
		on<ReqComproTambahEvent>(onTambahReqCompro);
	}

	Future<void> onTambahReqCompro(
		ReqComproTambahEvent event, Emitter<ReqComproState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.reqComproTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
			isSaving: false,
			isSaved: true,
			hasFailure: hasFailure));
	}

}