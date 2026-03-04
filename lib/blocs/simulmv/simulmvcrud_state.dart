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

  SimulmvCrudState copyWith({
    SimulmvCrudModel? record,
    bool? isLoading,
    bool? isLoaded,
    bool? isSaving,
    bool? isSaved,
    bool? hasFailure,
    ComboMMvjnscoverModel? comboMMvjnscover,
    ComboMWilayahModel? comboMWilayah,
    ComboMMvgrupOjkModel? comboMMvgrupOjk,
    bool? isCalculating,
    bool? isCalculated,
    List<String>? errors,
    bool? isFieldCascoChanged,
    bool? isFieldOpsiChanged,
  }) {
    return SimulmvCrudState(
        record: record ?? this.record,
        isLoading: isLoading ?? this.isLoading,
        isLoaded: isLoaded ?? this.isLoaded,
        isSaving: isSaving ?? this.isSaving,
        isSaved: isSaved ?? this.isSaved,
        hasFailure: hasFailure ?? this.hasFailure,
        comboMMvjnscover: comboMMvjnscover ?? this.comboMMvjnscover,
        comboMWilayah: comboMWilayah ?? this.comboMWilayah,
        comboMMvgrupOjk: comboMMvgrupOjk ?? this.comboMMvgrupOjk,
        isCalculating: isCalculating ?? this.isCalculating,
        isCalculated: isCalculated ?? this.isCalculated,
        errors: errors ?? this.errors,
        isFieldCascoChanged: isFieldCascoChanged ?? this.isFieldCascoChanged,
        isFieldOpsiChanged: isFieldOpsiChanged ?? this.isFieldOpsiChanged,);
  }

  @override
  List<Object> get props => [
        isLoading,
        isLoaded,
        isSaving,
        isSaved,
        hasFailure,
        isCalculating,
        isCalculated,
        isFieldCascoChanged,
        isFieldOpsiChanged
      ];
}
