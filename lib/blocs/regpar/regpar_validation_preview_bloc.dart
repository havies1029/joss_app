import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/regpar/regpar_validation_preview_model.dart';
import 'package:joss_app/repositories/regpar/regpar_validation_preview_repository.dart';

part 'regpar_validation_preview_event.dart';
part 'regpar_validation_preview_state.dart';

class RegparValidationPreviewBloc
    extends Bloc<RegparValidationPreviewEvent, RegparValidationPreviewState> {
  final RegparValidationPreviewRepository repository;

  RegparValidationPreviewBloc({required this.repository})
      : super(const RegparValidationPreviewState()) {
    on<RegparValidationPreviewCheckEvent>(_onCheck);
    on<RegparValidationPreviewResetEvent>(_onReset);
  }

  Future<void> _onCheck(
    RegparValidationPreviewCheckEvent event,
    Emitter<RegparValidationPreviewState> emit,
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
    RegparValidationPreviewResetEvent event,
    Emitter<RegparValidationPreviewState> emit,
  ) async {
    emit(const RegparValidationPreviewState());
  }
}
