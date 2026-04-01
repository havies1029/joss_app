import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combomjenisrugi_model.dart';
import 'package:joss_app/models/perbaruiklaimpar/klaimparklaimcrud_model.dart';
import 'package:joss_app/repositories/perbaruiklaimpar/klaimparklaimcrud_repository.dart';

part 'klaimparklaimcrud_event.dart';
part 'klaimparklaimcrud_state.dart';

class KlaimparklaimcrudBloc
    extends Bloc<KlaimparklaimcrudEvents, KlaimparklaimcrudState> {
  final KlaimparklaimcrudRepository repository;

  KlaimparklaimcrudBloc({required this.repository})
      : super(const KlaimparklaimcrudState()) {
    on<KlaimparklaimcrudUbahEvent>(onUbahKlaimparklaimcrud);
    on<KlaimparklaimcrudTambahEvent>(onTambahKlaimparklaimcrud);
    on<KlaimparklaimcrudHapusEvent>(onHapusKlaimparklaimcrud);
    on<KlaimparklaimcrudLihatEvent>(onLihatKlaimparklaimcrud);
    on<ComboMJenisrugiChangedEvent>(onComboMJenisrugiChanged);
    on<FieldDolChangedEvent>(onFieldDolChanged);
    on<FieldKeteranganChangedEvent>(onFieldKeteranganChanged);
    on<FieldLaporJpsChangedEvent>(onFieldLaporJpsChanged);
    on<FieldLaporAsuransiChangedEvent>(onFieldLaporAsuransiChanged);
    on<FieldPenyebabChangedEvent>(onFieldPenyebabChanged);
    on<FieldPicEmailChangedEvent>(onFieldPicEmailChanged);
    on<FieldPicJabatanChangedEvent>(onFieldPicJabatanChanged);
    on<FieldPicNamaChangedEvent>(onFieldPicNamaChanged);
    on<FieldPicTelpChangedEvent>(onFieldPicTelpChanged);
    on<KlaimparklaimcrudAutoSaveEvent>(onAutoSave);
  }

  Future<void> onTambahKlaimparklaimcrud(
      KlaimparklaimcrudTambahEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    ReturnDataAPI returnData;
    bool hasFailure = true;

    emit(state.copyWith(isSaving: true, isSaved: false));

    returnData = await repository.klaimparklaimcrudTambah(event.record);
    hasFailure = !returnData.success;

    emit(state.copyWith(
      isSaving: false,
      isSaved: true,
      hasFailure: hasFailure,
    ));
  }

  Future<void> onUbahKlaimparklaimcrud(
      KlaimparklaimcrudUbahEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    emit(state.copyWith(isSaving: true, isSaved: false));

    bool hasFailure = !await repository.klaimparklaimcrudUbah(event.record);

    emit(state.copyWith(
      isSaving: false,
      isSaved: true,
      hasFailure: hasFailure,
    ));
  }

  Future<void> onHapusKlaimparklaimcrud(
      KlaimparklaimcrudHapusEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    emit(state.copyWith(isSaving: true, isSaved: false));

    bool hasFailure = !await repository.klaimparklaimcrudHapus(event.recordId);

    emit(state.copyWith(
      isSaving: false,
      isSaved: true,
      hasFailure: hasFailure,
    ));
  }

  Future<void> onLihatKlaimparklaimcrud(
      KlaimparklaimcrudLihatEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));

    KlaimparklaimcrudModel? record =
    await repository.klaimparklaimcrudLihat(event.recordId);

    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      record: record,
      comboMJenisrugi: record?.comboMJenisrugi,
      isComplete: _isComplete(record),
      isValid: _isValid(record),
    ));
  }

  Future<void> onComboMJenisrugiChanged(
      ComboMJenisrugiChangedEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));

    KlaimparklaimcrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(
        mjenisrugiId: event.comboMJenisrugi.mjenisrugiId,
      );
    }

    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      comboMJenisrugi: event.comboMJenisrugi,
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
      isValid: _isValid(record),
    ));
  }

  Future<void> onFieldDolChanged(
      FieldDolChangedEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    KlaimparklaimcrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(dol: event.dol);
    }

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
      isValid: _isValid(record),
    ));
  }

  Future<void> onFieldKeteranganChanged(
      FieldKeteranganChangedEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    KlaimparklaimcrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(keterangan: event.keterangan);
    }

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
      isValid: _isValid(record),
    ));
  }

  Future<void> onFieldLaporJpsChanged(
      FieldLaporJpsChangedEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    KlaimparklaimcrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(laporJps: event.laporJps);
    }

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
      isValid: _isValid(record),
    ));
  }

  Future<void> onFieldLaporAsuransiChanged(
      FieldLaporAsuransiChangedEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    KlaimparklaimcrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(laporAsuransi: event.laporAsuransi);
    }

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
      isValid: _isValid(record),
    ));
  }

  Future<void> onFieldPenyebabChanged(
      FieldPenyebabChangedEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    KlaimparklaimcrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(penyebab: event.penyebab);
    }

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
      isValid: _isValid(record),
    ));
  }

  Future<void> onFieldPicEmailChanged(
      FieldPicEmailChangedEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    KlaimparklaimcrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(picEmail: event.picEmail);
    }

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
      isValid: _isValid(record),
    ));
  }

  Future<void> onFieldPicJabatanChanged(
      FieldPicJabatanChangedEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    KlaimparklaimcrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(picJabatan: event.picJabatan);
    }

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
      isValid: _isValid(record),
    ));
  }

  Future<void> onFieldPicNamaChanged(
      FieldPicNamaChangedEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    KlaimparklaimcrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(picNama: event.picNama);
    }

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
      isValid: _isValid(record),
    ));
  }

  Future<void> onFieldPicTelpChanged(
      FieldPicTelpChangedEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    KlaimparklaimcrudModel? record = state.record;
    if (record != null) {
      record = record.copyWith(picTelp: event.picTelp);
    }

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
      isValid: _isValid(record),
    ));
  }

  Future<void> onAutoSave(
      KlaimparklaimcrudAutoSaveEvent event,
      Emitter<KlaimparklaimcrudState> emit,
      ) async {
    if (!state.isDirty || state.record == null || !state.isValid) return;

    emit(state.copyWith(isSaving: true, isSaved: false));

    bool hasFailure = !await repository.klaimparklaimcrudUbah(state.record!);

    emit(state.copyWith(
      isSaving: false,
      isSaved: true,
      hasFailure: hasFailure,
      isDirty: false,
    ));
  }

  bool _isComplete(KlaimparklaimcrudModel? record) {
    if (record == null) return false;

    return
      _hasDate(record.dol) &&
          _hasValue(record.mjenisrugiId) &&
          _hasText(record.keterangan) &&
          _hasText(record.penyebab) &&
          _hasText(record.picNama) &&
          _hasText(record.picJabatan) &&
          _hasText(record.picEmail) &&
          _hasText(record.picTelp);
  }

  bool _isValid(KlaimparklaimcrudModel? record) {
    if (record == null) return false;
    if (!_isComplete(record)) return false;

    return _isSameOrBeforeToday(record.dol);
  }

  bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  bool _hasValue(dynamic value) {
    if (value == null) return false;
    if (value is String) return value.trim().isNotEmpty;
    return true;
  }

  bool _hasDate(DateTime? value) {
    return value != null;
  }

  bool _isSameOrBeforeToday(DateTime? date) {
    if (date == null) return false;

    final today = DateTime.now();
    final d1 = DateTime(date.year, date.month, date.day);
    final d2 = DateTime(today.year, today.month, today.day);

    return !d1.isAfter(d2);
  }
}