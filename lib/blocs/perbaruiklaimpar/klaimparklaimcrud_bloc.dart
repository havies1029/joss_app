import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/combobox/combomjenisrugi_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
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
    on<ComboRMatauangChangedEvent>(onComboRMatauangChanged);

    on<FieldDolChangedEvent>(onFieldDolChanged);
    on<FieldKeteranganChangedEvent>(onFieldKeteranganChanged);
    on<FieldLaporJpsChangedEvent>(onFieldLaporJpsChanged);
    on<FieldLaporAsuransiChangedEvent>(onFieldLaporAsuransiChanged);
    on<FieldPenyebabChangedEvent>(onFieldPenyebabChanged);
    on<FieldPicEmailChangedEvent>(onFieldPicEmailChanged);
    on<FieldPicJabatanChangedEvent>(onFieldPicJabatanChanged);
    on<FieldPicNamaChangedEvent>(onFieldPicNamaChanged);
    on<FieldPicTelpChangedEvent>(onFieldPicTelpChanged);
    on<FieldKlaimAmountChangedEvent>(onFieldKlaimAmountChanged);
    on<FieldCurrIdChangedEvent>(onFieldCurrIdChanged);
    on<KlaimparklaimcrudAutoSaveEvent>(onAutoSave);
  }

  Future<void> onTambahKlaimparklaimcrud(
    KlaimparklaimcrudTambahEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, isSaved: false));

    final returnData = await repository.klaimparklaimcrudTambah(event.record);
    final hasFailure = !returnData.success;

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

    final hasFailure = !await repository.klaimparklaimcrudUbah(event.record);

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

    final hasFailure = !await repository.klaimparklaimcrudHapus(event.recordId);

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

    final record = await repository.klaimparklaimcrudLihat(event.recordId);

    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      record: record,
      comboMJenisrugi: record?.comboMJenisrugi,
      comboRMatauang: record?.comboRMatauang,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onComboMJenisrugiChanged(
    ComboMJenisrugiChangedEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    KlaimparklaimcrudModel? record = state.record;

    if (record != null) {
      record = record.copyWith(
        mjenisrugiId: event.comboMJenisrugi.mjenisrugiId,
        comboMJenisrugi: event.comboMJenisrugi,
      );
    }

    emit(state.copyWith(
      comboMJenisrugi: event.comboMJenisrugi,
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onComboRMatauangChanged(
    ComboRMatauangChangedEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    KlaimparklaimcrudModel? record = state.record;

    if (record != null) {
      record = record.copyWith(
        currId: event.comboRMatauang.rmatauangKode,
        comboRMatauang: event.comboRMatauang,
      );
    }

    emit(state.copyWith(
      comboRMatauang: event.comboRMatauang,
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onFieldCurrIdChanged(
    FieldCurrIdChangedEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    final record = state.record?.copyWith(currId: event.currId);

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onFieldDolChanged(
    FieldDolChangedEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    final record = state.record?.copyWith(dol: event.dol);

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onFieldKeteranganChanged(
    FieldKeteranganChangedEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    final record = state.record?.copyWith(keterangan: event.keterangan);

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onFieldLaporJpsChanged(
    FieldLaporJpsChangedEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    final record = state.record?.copyWith(laporJps: event.laporJps);

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onFieldLaporAsuransiChanged(
    FieldLaporAsuransiChangedEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    final record = state.record?.copyWith(laporAsuransi: event.laporAsuransi);

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onFieldPenyebabChanged(
    FieldPenyebabChangedEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    final record = state.record?.copyWith(penyebab: event.penyebab);

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onFieldPicEmailChanged(
    FieldPicEmailChangedEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    final record = state.record?.copyWith(picEmail: event.picEmail);

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onFieldPicJabatanChanged(
    FieldPicJabatanChangedEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    final record = state.record?.copyWith(picJabatan: event.picJabatan);

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onFieldPicNamaChanged(
    FieldPicNamaChangedEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    final record = state.record?.copyWith(picNama: event.picNama);

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onFieldPicTelpChanged(
    FieldPicTelpChangedEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    final record = state.record?.copyWith(picTelp: event.picTelp);

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onFieldKlaimAmountChanged(
    FieldKlaimAmountChangedEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    final record = state.record?.copyWith(klaimAmount: event.klaimAmount);

    emit(state.copyWith(
      record: record,
      isDirty: true,
      isComplete: _isComplete(record),
    ));
  }

  Future<void> onAutoSave(
    KlaimparklaimcrudAutoSaveEvent event,
    Emitter<KlaimparklaimcrudState> emit,
  ) async {
    if (!state.isDirty || state.record == null) return;

    emit(state.copyWith(isSaving: true, isSaved: false));

    final hasFailure = !await repository.klaimparklaimcrudUbah(state.record!);

    emit(state.copyWith(
      isSaving: false,
      isSaved: true,
      hasFailure: hasFailure,
      isDirty: false,
    ));
  }

  bool _isComplete(KlaimparklaimcrudModel? record) {
    if (record == null) return false;

    return _hasValue(record.mjenisrugiId) &&
        _hasText(record.keterangan) &&
        _hasText(record.penyebab) &&
        _hasText(record.picNama) &&
        _hasText(record.picJabatan) &&
        _hasText(record.picEmail) &&
        _hasValue(record.currId) &&
        record.klaimAmount > 0;
  }

  bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  bool _hasValue(dynamic value) {
    if (value == null) return false;
    if (value is String) return value.trim().isNotEmpty;
    return true;
  }
}
