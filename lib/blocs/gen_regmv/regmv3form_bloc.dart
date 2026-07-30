import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/combommvmerk_model.dart';
import 'package:joss_app/models/combobox/combommvtipe_model.dart';
import 'package:joss_app/models/combobox/combommvmodel_model.dart';
import 'package:joss_app/models/combobox/combomwarna_model.dart';
import 'package:joss_app/models/combobox/combommvpakai_model.dart';
import 'package:joss_app/models/gen_regmv/regmv3form_model.dart';
import 'package:joss_app/repositories/gen_regmv/regmv3form_repository.dart';

part 'regmv3form_event.dart';
part 'regmv3form_state.dart';

class Regmv3FormBloc extends Bloc<Regmv3FormEvents, Regmv3FormState> {
  final Regmv3FormRepository repository;
  Regmv3FormBloc({required this.repository}) : super(const Regmv3FormState()) {
    on<Regmv3FormUbahEvent>(onUbahRegmv3Form);
    on<Regmv3FormTambahEvent>(onTambahRegmv3Form);
    on<Regmv3FormHapusEvent>(onHapusRegmv3Form);
    on<Regmv3FormLihatEvent>(onLihatRegmv3Form);
    on<ComboMWilayahChangedEvent>(onComboMWilayahChanged);
    on<ComboMMvmerkChangedEvent>(onComboMMvmerkChanged);
    on<ComboMMvtipeChangedEvent>(onComboMMvtipeChanged);
    on<ComboMMvmodelChangedEvent>(onComboMMvmodelChanged);
    on<ComboMWarnaChangedEvent>(onComboMWarnaChanged);
    on<ComboMMvpakaiChangedEvent>(onComboMMvpakaiChanged);
    on<FieldThnBuatChangedEvent>(onFieldThnBuatChanged);
    on<FieldAksesorisChangedEvent>(onFieldAksesorisChanged);
    on<FieldHargaChangedEvent>(onFieldHargaChanged);
    on<FieldMesinNoChangedEvent>(onFieldMesinNoChanged);
    on<FieldPlatNoChangedEvent>(onFieldPlatNoChanged);
    on<FieldRangkaNoChangedEvent>(onFieldRangkaNoChanged);
    on<Regmv3DraftEvent>(onDraftRegmv3Crud);
  }

  Future<void> onDraftRegmv3Crud(
    Regmv3DraftEvent event,
    Emitter<Regmv3FormState> emit,
  ) async {
    emit(state.copyWith(
      record: event.record,
      // opsional kalau mau reset flag:
      // isSaved: false,
      // hasFailure: false,
    ));
  }

  Future<void> onTambahRegmv3Form(
    Regmv3FormTambahEvent event,
    Emitter<Regmv3FormState> emit,
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
      returnData = await repository.regmv3FormTambah(event.record);
    } catch (e) {
      returnData =
          ReturnDataAPI(success: false, data: e.toString(), rowcount: 0);
    }

    final bool hasFailure = !returnData.success;

    if (!hasFailure) {
      final newId = returnData.data.toString();

      final updatedRecord = event.record;
      updatedRecord.regmv3Id = newId;

      emit(state.copyWith(
        isSaving: false,
        isSaved: true,
        hasFailure: false,
        failureMessage: '',
        failureKind: '',
        record: updatedRecord,
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

  Future<void> onUbahRegmv3Form(
    Regmv3FormUbahEvent event,
    Emitter<Regmv3FormState> emit,
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
      returnData = await repository.regmv3FormUbah(event.record);
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

  Future<void> onHapusRegmv3Form(
      Regmv3FormHapusEvent event, Emitter<Regmv3FormState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    bool hasFailure = !await repository.regmv3FormHapus(event.recordId);
    emit(
        state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
  }

  Future<void> onLihatRegmv3Form(
      Regmv3FormLihatEvent event, Emitter<Regmv3FormState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));
    Regmv3FormModel record = await repository.regmv3FormLihat(event.recordId);
    emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
  }

  Future<void> onComboMWilayahChanged(
      ComboMWilayahChangedEvent event, Emitter<Regmv3FormState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));

    ComboMWilayahModel comboMWilayah = event.comboMWilayah;
    emit(state.copyWith(
        isLoading: false, isLoaded: true, comboMWilayah: comboMWilayah));
  }

  Future<void> onComboMMvmerkChanged(
      ComboMMvmerkChangedEvent event, Emitter<Regmv3FormState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));

    ComboMMvmerkModel comboMMvmerk = event.comboMMvmerk;
    emit(state.copyWith(
        isLoading: false, isLoaded: true, comboMMvmerk: comboMMvmerk));
  }

  Future<void> onComboMMvtipeChanged(
      ComboMMvtipeChangedEvent event, Emitter<Regmv3FormState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));

    ComboMMvtipeModel comboMMvtipe = event.comboMMvtipe;
    emit(state.copyWith(
        isLoading: false, isLoaded: true, comboMMvtipe: comboMMvtipe));
  }

  Future<void> onComboMMvmodelChanged(
      ComboMMvmodelChangedEvent event, Emitter<Regmv3FormState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));

    ComboMMvmodelModel comboMMvmodel = event.comboMMvmodel;
    emit(state.copyWith(
        isLoading: false, isLoaded: true, comboMMvmodel: comboMMvmodel));
  }

  Future<void> onComboMWarnaChanged(
      ComboMWarnaChangedEvent event, Emitter<Regmv3FormState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));

    ComboMWarnaModel comboMWarna = event.comboMWarna;
    emit(state.copyWith(
        isLoading: false, isLoaded: true, comboMWarna: comboMWarna));
  }

  Future<void> onComboMMvpakaiChanged(
      ComboMMvpakaiChangedEvent event, Emitter<Regmv3FormState> emit) async {
    emit(state.copyWith(isLoading: true, isLoaded: false));

    ComboMMvpakaiModel comboMMvpakai = event.comboMMvpakai;
    emit(state.copyWith(
        isLoading: false, isLoaded: true, comboMMvpakai: comboMMvpakai));
  }

  Future<void> onFieldThnBuatChanged(
      FieldThnBuatChangedEvent event, Emitter<Regmv3FormState> emit) async {
    Regmv3FormModel? record = state.record;
    int thnBuat = int.tryParse(event.thnBuat) ?? 0;
    record = record?.copyWith(thnBuat: thnBuat);

    emit(state.copyWith(record: record));
  }

  Future<void> onFieldAksesorisChanged(
      FieldAksesorisChangedEvent event, Emitter<Regmv3FormState> emit) async {
    Regmv3FormModel? record = state.record;
    record = record?.copyWith(aksesoris: event.aksesoris);

    emit(state.copyWith(record: record));
  }

  Future<void> onFieldHargaChanged(
      FieldHargaChangedEvent event, Emitter<Regmv3FormState> emit) async {
    Regmv3FormModel? record = state.record;
    double harga = double.tryParse(event.harga) ?? 0.0;
    record = record?.copyWith(harga: harga);

    emit(state.copyWith(record: record));
  }

  Future<void> onFieldMesinNoChanged(
      FieldMesinNoChangedEvent event, Emitter<Regmv3FormState> emit) async {
    Regmv3FormModel? record = state.record;
    record = record?.copyWith(mesinNo: event.mesinNo);

    emit(state.copyWith(record: record));
  }

  Future<void> onFieldPlatNoChanged(
      FieldPlatNoChangedEvent event, Emitter<Regmv3FormState> emit) async {
    Regmv3FormModel? record = state.record;
    record = record?.copyWith(platNo: event.platNo);

    emit(state.copyWith(record: record));
  }

  Future<void> onFieldRangkaNoChanged(
      FieldRangkaNoChangedEvent event, Emitter<Regmv3FormState> emit) async {
    Regmv3FormModel? record = state.record;
    record = record?.copyWith(rangkaNo: event.rangkaNo);

    emit(state.copyWith(record: record));
  }

  String _failureKindFor(String message) {
    final msg = message.trim();
    if (msg.isEmpty) return 'technical';
    if (msg.contains(' Line : ') && msg.contains(' di ')) return 'technical';
    return _isBackendValidationMessage(msg) ? 'validation' : 'technical';
  }

  bool _isBackendValidationMessage(String message) {
    if (message.startsWith('Kode Area Plat (') &&
        message.endsWith(') tidak ditemukan!')) {
      return true;
    }

    const messages = {
      'Running Number tidak boleh kosong!',
      'Running Number tidak terdaftar!',
      'Wilayah tidak boleh kosong!',
      'Nomor Plat tidak boleh kosong!',
      'Nomor Mesin tidak boleh kosong!',
      'Nomor Rangka tidak boleh kosong!',
      'Merk, Tipe, dan Model Kendaraan tidak boleh kosong!',
      'Warna Kendaraan tidak boleh kosong!',
      'Penggunaan Kendaraan tidak boleh kosong!',
      'Tahun Kendaraan tidak boleh 0!',
      'Tahun Kendaraan tidak valid!',
      'Harga Kendaraan harus lebih besar dari 0!',
      'Wilayah tidak sesuai data master!',
      'Merk Kendaraan tidak sesuai data master!',
      'Tipe Kendaraan tidak sesuai dengan Merk Kendaraan!',
      'Model Kendaraan tidak sesuai dengan Tipe Kendaraan!',
      'Harga Kendaraan di luar batas price list untuk Model dan Tahun Kendaraan!',
      'Maksimal usia Kendaraan Listrik (Mobil/Motor) adalah 3 tahun!',
      'Kendaraan Motor hanya dapat menggunakan jaminan Total Loss Only!',
      'Jaminan Authorized Workshop hanya berlaku untuk usia kendaraan maksimal 15 tahun!',
      'Warna Kendaraan tidak sesuai data master!',
      'Penggunaan Kendaraan tidak sesuai data master!',
      'Format Plat tidak sesuai! Format : "Kode Nomor Alphabet"',
      'Nomor Plat harus angka!',
    };

    return messages.contains(message);
  }
}
