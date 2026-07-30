import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/models/gen_regmv/regmv2form_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv2form_repository.dart';

part 'regmv2form_event.dart';
part 'regmv2form_state.dart';

class Regmv2FormBloc extends Bloc<Regmv2FormEvents, Regmv2FormState> {
  final Regmv2FormRepository repository;
  Regmv2FormBloc({required this.repository}) : super(const Regmv2FormState()) {
    on<Regmv2FormUbahEvent>(onUbahRegmv2Form);
    on<Regmv2FormTambahEvent>(onTambahRegmv2Form);
    on<Regmv2FormHapusEvent>(onHapusRegmv2Form);
    on<Regmv2FormLihatEvent>(onLihatRegmv2Form);
    on<ComboMMvjnscoverChangedEvent>(onComboMMvjnscoverChanged);
    on<ComboRMatauangChangedEvent>(onComboRMatauangChanged);
    on<Regmv2DraftEvent>(onDraftRegmv2Crud);
  }

  Future<void> onDraftRegmv2Crud(
    Regmv2DraftEvent event,
    Emitter<Regmv2FormState> emit,
  ) async {
    emit(state.copyWith(
      record: event.record,
      // opsional kalau mau reset flag:
      // isSaved: false,
      // hasFailure: false,
    ));
  }

  Future<void> onTambahRegmv2Form(
    Regmv2FormTambahEvent event,
    Emitter<Regmv2FormState> emit,
  ) async {
    emit(state.copyWith(
      isSaving: true,
      isSaved: false,
      hasFailure: false,
      failureMessage: '',
      failureKind: '',
    ));

    ReturnDataAPI returnData;
    try {
      returnData = await repository.regmv2FormTambah(event.record);
    } catch (e) {
      returnData =
          ReturnDataAPI(success: false, data: e.toString(), rowcount: 0);
    }

    final bool hasFailure = !returnData.success;

    if (!hasFailure) {
      // 🔥 ambil regmv2Id baru dari server
      final newId = returnData.data.toString();

      final updatedRecord = event.record;
      updatedRecord.regmv2Id = newId;

      emit(state.copyWith(
        isSaving: false,
        isSaved: true,
        hasFailure: false,
        failureMessage: '',
        failureKind: '',
        record: updatedRecord, // << PENTING: biar UI bisa baca regmv2Id
      ));
    } else {
      final message = returnData.data.toString();
      emit(state.copyWith(
        isSaving: false,
        isSaved: false,
        hasFailure: true,
        failureMessage: message,
        failureKind: _failureKindFor(message),
        record: event.record,
      ));
    }
  }

  Future<void> onUbahRegmv2Form(
    Regmv2FormUbahEvent event,
    Emitter<Regmv2FormState> emit,
  ) async {
    emit(state.copyWith(
      isSaving: true,
      isSaved: false,
      hasFailure: false,
      failureMessage: '',
      failureKind: '',
    ));

    ReturnDataAPI returnData;
    try {
      returnData = await repository.regmv2FormUbah(event.record);
    } catch (e) {
      returnData =
          ReturnDataAPI(success: false, data: e.toString(), rowcount: 0);
    }
    final hasFailure = !returnData.success;
    final message = hasFailure ? returnData.data.toString() : '';

    emit(state.copyWith(
      isSaving: false,
      isSaved: !hasFailure,
      hasFailure: hasFailure,
      failureMessage: message,
      failureKind: hasFailure ? _failureKindFor(message) : '',
      record: event.record,
    ));
  }

  Future<void> onHapusRegmv2Form(
      Regmv2FormHapusEvent event, Emitter<Regmv2FormState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    bool hasFailure = !await repository.regmv2FormHapus(event.recordId);
    emit(
        state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onLihatRegmv2Form(
      Regmv2FormLihatEvent event, Emitter<Regmv2FormState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    Regmv2FormModel record = await repository.regmv2FormLihat(event.recordId);
    emit(state.copyWith(
        isLoading: false,
        isLoaded: true,
        record: record,
        comboMMvjnscover: record.comboMMvjnscover,
        comboRMatauang: record.comboRMatauang));
  }

  Future<void> onComboMMvjnscoverChanged(
      ComboMMvjnscoverChangedEvent event, Emitter<Regmv2FormState> emit) async {
    ComboMMvjnscoverModel comboMMvjnscover = event.comboMMvjnscover;
    emit(state.copyWith(comboMMvjnscover: comboMMvjnscover));
  }

  Future<void> onComboRMatauangChanged(
      ComboRMatauangChangedEvent event, Emitter<Regmv2FormState> emit) async {
    ComboRMatauangModel comboRMatauang = event.comboRMatauang;
    emit(state.copyWith(comboRMatauang: comboRMatauang));
  }

  String _failureKindFor(String message) {
    final msg = message.trim();
    if (msg.isEmpty) return 'technical';
    if (msg.contains(' Line : ') && msg.contains(' di ')) return 'technical';
    return _isBackendValidationMessage(msg) ? 'validation' : 'technical';
  }

  bool _isBackendValidationMessage(String message) {
    const messages = {
      'Running Number tidak boleh kosong!',
      'Running Number tidak terdaftar!',
      'Tanggal mulai polis tidak boleh kosong!',
      'Tanggal akhir polis tidak boleh kosong!',
      'Jenis Coverage tidak boleh kosong!',
      'Mata Uang tidak boleh kosong!',
      'Pilihan perluasan jaminan tidak boleh kosong!',
      'Jumlah Penumpang tidak boleh kosong!',
      'Tanggal akhir polis harus lebih besar dari tanggal mulai!',
      'Periode Polis harus tepat 1 tahun!',
      'Batas Backdate 30 hari dari Inception Date!',
      'Nilai TPL/PAD/PAP/PLL tidak boleh negatif!',
      'Jumlah Penumpang harus antara 0 sampai 7!',
      'Jenis Coverage tidak sesuai data master!',
      'Mata Uang tidak sesuai data master!',
    };

    return messages.contains(message);
  }
}
