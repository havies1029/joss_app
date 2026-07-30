import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/gen_regmv/regmv_validation_preview_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv_validation_preview_repository.dart';

part 'regmv_validation_preview_event.dart';
part 'regmv_validation_preview_state.dart';

class RegmvValidationPreviewBloc
    extends Bloc<RegmvValidationPreviewEvent, RegmvValidationPreviewState> {
  final RegmvValidationPreviewRepository repository;

  RegmvValidationPreviewBloc({required this.repository})
      : super(const RegmvValidationPreviewState()) {
    on<RegmvValidationPreviewCheckEvent>(_onCheck);
    on<RegmvValidationPreviewResetEvent>(_onReset);
  }

  Future<void> _onCheck(
    RegmvValidationPreviewCheckEvent event,
    Emitter<RegmvValidationPreviewState> emit,
  ) async {
    emit(state.copyWith(
      isChecking: true,
      isChecked: false,
      hasFailure: false,
    ));

    final response = await repository.check(event.record);

    emit(state.copyWith(
      isChecking: false,
      isChecked: true,
      hasFailure: !response.success,
      response: response,
    ));
  }

  Future<void> _onReset(
    RegmvValidationPreviewResetEvent event,
    Emitter<RegmvValidationPreviewState> emit,
  ) async {
    emit(const RegmvValidationPreviewState());
  }
}
