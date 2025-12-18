import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/calpar/calpar4form_model.dart';
import 'package:joss_app/repositories/calpar/calpar4form_repository.dart';

part 'calpar4form_event.dart';
part 'calpar4form_state.dart';

class Calpar4FormBloc extends Bloc<Calpar4FormEvents, Calpar4FormState> {
	final Calpar4FormRepository repository;
	Calpar4FormBloc({required this.repository}) : super(const Calpar4FormState()) {
		on<Calpar4FormUbahEvent>(onUbahCalpar4Form);
		on<Calpar4FormTambahEvent>(onTambahCalpar4Form);
		on<Calpar4FormHapusEvent>(onHapusCalpar4Form);
		on<Calpar4FormLihatEvent>(onLihatCalpar4Form);
		on<Calpar4FormHitungPremiEvent>(onHitungPremiCalpar4Form);
	}

	Future<void> onTambahCalpar4Form(
			Calpar4FormTambahEvent event, Emitter<Calpar4FormState> emit) async {

		ReturnDataAPI returnData;
		bool hasFailure = true;
		emit(state.copyWith(isSaving: true, isSaved: false));
		returnData = await repository.calpar4FormTambah(event.record);
		hasFailure = !returnData.success;
		emit(state.copyWith(
				isSaving: false,
				isSaved: true,
				hasFailure: hasFailure));
	}

	Future<void> onUbahCalpar4Form(
			Calpar4FormUbahEvent event, Emitter<Calpar4FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calpar4FormUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusCalpar4Form(
			Calpar4FormHapusEvent event, Emitter<Calpar4FormState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.calpar4FormHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatCalpar4Form(
			Calpar4FormLihatEvent event, Emitter<Calpar4FormState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		Calpar4FormModel record = await repository.calpar4FormLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

	Future<void> onHitungPremiCalpar4Form(
			Calpar4FormHitungPremiEvent event,
			Emitter<Calpar4FormState> emit) async {

		debugPrint("🔵 [BLoC] HITUNG PREMI TRIGGERED");
		debugPrint("🔵 [BLoC] calpar1Id => ${event.calpar1Id}");

		// Step 1: Mulai proses
		debugPrint("🟡 [BLoC] Emit: isCalculating = true, isCalculated = false");
		emit(state.copyWith(isCalculating: true, isCalculated: false));

		try {
			// Step 2: Call API
			debugPrint("🟡 [BLoC] Requesting API Calpar4FormHitungPremi...");
			Calpar4FormModel record =
			await repository.calpar4FormHitungPremi(event.calpar1Id);

			debugPrint("🟢 [BLoC] API SUCCESS — Record received:");
			debugPrint("🟢 [BLoC] premiNet: ${record.premiNet}");
			debugPrint("🟢 [BLoC] premiPar: ${record.premiPar}");
			debugPrint("🟢 [BLoC] premiEqvet: ${record.premiEqvet}");

			// Step 3: Emit data
			debugPrint("🟢 [BLoC] Emit: isCalculating = false, isCalculated = true, record updated");
			emit(state.copyWith(
				isCalculating: false,
				isCalculated: true,
				record: record,
			));
		} catch (e) {
			debugPrint("🔴 [BLoC] ERROR: $e");
			emit(state.copyWith(
				isCalculating: false,
				isCalculated: false,
				hasFailure: true,
			));
		}
	}


}