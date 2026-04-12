part of 'simulmvcrud_bloc.dart';

class SimulmvCrudState extends Equatable {
  final SimulmvCrudModel? record;
  final bool isLoading;
  final bool isLoaded;
  final bool isSaving;
  final bool isSaved;
  final bool hasFailure;
  final bool isCalculating;
  final bool isCalculated;
  final bool isFieldCascoChanged;
  final bool isFieldOpsiChanged;
  final ComboMMvjnscoverModel? comboMMvjnscover;
  final ComboMWilayahModel? comboMWilayah;
  final ComboMMvgrupOjkModel? comboMMvgrupOjk;
  final List<String>? errors;

  const SimulmvCrudState({
    this.record,
    this.isLoading = false,
    this.isLoaded = false,
    this.isSaving = false,
    this.isSaved = false,
    this.hasFailure = false,
    this.comboMMvjnscover,
    this.comboMWilayah,
    this.comboMMvgrupOjk,
    this.isCalculating = false,
    this.isCalculated = false,
    this.errors,
    this.isFieldCascoChanged = false,
    this.isFieldOpsiChanged = false
  });

  static const _sentinel = Object();

  SimulmvCrudState copyWith({
    Object? record = _sentinel,
    bool? isLoading,
    bool? isLoaded,
    bool? isSaving,
    bool? isSaved,
    bool? hasFailure,
    Object? comboMMvjnscover = _sentinel,
    Object? comboMWilayah = _sentinel,
    Object? comboMMvgrupOjk = _sentinel,
    bool? isCalculating,
    bool? isCalculated,
    List<String>? errors,
    bool? isFieldCascoChanged,
    bool? isFieldOpsiChanged,
  }) {
    return SimulmvCrudState(
        record: identical(record, _sentinel) ? this.record : record as SimulmvCrudModel?,
        isLoading: isLoading ?? this.isLoading,
        isLoaded: isLoaded ?? this.isLoaded,
        isSaving: isSaving ?? this.isSaving,
        isSaved: isSaved ?? this.isSaved,
        hasFailure: hasFailure ?? this.hasFailure,
        comboMMvjnscover: identical(comboMMvjnscover, _sentinel) ? this.comboMMvjnscover : comboMMvjnscover as ComboMMvjnscoverModel?,
        comboMWilayah: identical(comboMWilayah, _sentinel) ? this.comboMWilayah : comboMWilayah as ComboMWilayahModel?,
        comboMMvgrupOjk: identical(comboMMvgrupOjk, _sentinel) ? this.comboMMvgrupOjk : comboMMvgrupOjk as ComboMMvgrupOjkModel?,
        isCalculating: isCalculating ?? this.isCalculating,
        isCalculated: isCalculated ?? this.isCalculated,
        errors: errors ?? this.errors,
        isFieldCascoChanged: isFieldCascoChanged ?? this.isFieldCascoChanged,
        isFieldOpsiChanged: isFieldOpsiChanged ?? this.isFieldOpsiChanged,);
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLoaded,
        isSaving,
        isSaved,
        hasFailure,
        isCalculating,
        isCalculated,
        isFieldCascoChanged,
        isFieldOpsiChanged,
        record ?? '',
        comboMMvjnscover ?? '',
        comboMWilayah ?? '',
        comboMMvgrupOjk ?? '',
        errors ?? ''
      ];
}
