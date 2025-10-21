import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/authentication/auth_model.dart';
import 'package:joss_app/models/user/user_model.dart';
import 'package:joss_app/repositories/user/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/login/emailverification_model.dart';
import 'package:joss_app/repositories/login/emailverification_repository.dart';

part 'emailverification_event.dart';
part 'emailverification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvents, EmailVerificationState> {
  final EmailVerificationRepository repository;
  final AuthenticationBloc authenticationBloc;

  EmailVerificationBloc(
      {required this.repository, required this.authenticationBloc})
      : super(const EmailVerificationState()) {
    on<EmailVerificationTambahEvent>(onTambahEmailVerification);
    on<ValidasiPinEmailEvent>(onValidasiPinEmail);
    on<FieldSimpanPasswordChangedEvent>(onFieldSimpanPasswordChangedEvent);
  }

  Future<void> onTambahEmailVerification(
      EmailVerificationTambahEvent event,
      Emitter<EmailVerificationState> emit,
      ) async {
    ReturnDataAPI returnData;
    bool hasFailure = true;

    debugPrint("🔹 [onTambahEmailVerification] STARTED");
    debugPrint("📩 Record dikirim: ${event.record.toJson()}");

    emit(state.copyWith(isLoading: true, isLoaded: false, hasFailure: false));

    // 🔍 Panggil repository
    debugPrint("🚀 Memanggil repository.emailVerificationTambah...");
    returnData = await repository.emailVerificationTambah(event.record);

    // 🔎 Log hasil response dari repository
    debugPrint("📥 Response dari repository:");
    debugPrint("    success: ${returnData.success}");
    debugPrint("    data: ${returnData.data}");
    debugPrint("    rowcount: ${returnData.rowcount}");

    hasFailure = !returnData.success;
    List<String> errors = [];

    // 🔎 Cek apakah response success
    if (!hasFailure) {
      if (returnData.data.isEmpty) {
        debugPrint("⚠️ returnData.data kosong — kemungkinan API belum kirim data yang diharapkan");
      } else {
        List<String> infoData = returnData.data.split(";");
        debugPrint("🧩 infoData setelah split: $infoData");

        if ((infoData[0] == '1') || (infoData[0] == '3')) {
          debugPrint("✅ Status login berhasil (kode ${infoData[0]})");

          Token token = Token.split(event.record.email, infoData[1]);
          UserRepository userRepository = UserRepository();

          User user = User(
            id: 0,
            username: event.record.email,
            email: event.record.email,
            token: token.token,
            custType: 'U',
          );

          AppData.user = user;
          AppData.userToken = token.token!;

          debugPrint("🔐 Token diset: ${token.token}");
          debugPrint("👤 User diset di AppData: ${user.email}");

          if (state.isSimpanPassword) {
            debugPrint("💾 Simpan password di local storage...");
            userRepository.persistToken(userToken: token.token!);
          }

          authenticationBloc.add(UserAuthenticated(user: user));
          debugPrint("📡 Event UserAuthenticated dikirim ke AuthenticationBloc");
        } else if (infoData[0] == '2') {
          debugPrint("📲 Status OTP diperlukan (kode 2)");
          AppData.isInOtpProcess = true;
          event.record.requestId = infoData[1];

          authenticationBloc.add(
            RequirePinEmailVerification(email: event.record.email),
          );

          debugPrint("📡 Event RequirePinEmailVerification dikirim");
        } else {
          debugPrint("⚠️ Status tidak dikenal: ${infoData[0]}");
        }
      }
    } else if (returnData.data.isNotEmpty) {
      debugPrint("❌ Gagal, tapi ada data error dari API: ${returnData.data}");
      List<String> infoData = returnData.data.split(";");
      if (infoData[0] == '9') {
        errors.add(infoData[1]);
        debugPrint("🚨 Error code 9: ${infoData[1]}");

        authenticationBloc.add(RequireLoginClient(
          requiredFrom: "bloc_email_verification",
          errorMsg: infoData[1],
        ));
      }
    } else {
      debugPrint("❌ Gagal tanpa data (returnData.data kosong)");
    }

    debugPrint("🏁 [onTambahEmailVerification] SELESAI\n");

    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      hasFailure: hasFailure,
      record: event.record,
      errors: errors,
    ));
  }

  Future<void> onValidasiPinEmail(
      ValidasiPinEmailEvent event, Emitter<EmailVerificationState> emit) async {
    ReturnDataAPI returnData;
    bool hasFailure = true;
    emit(state.copyWith(
        isLoading: true, isLoaded: false, verificationFailed: false));
    event.record.requestId = state.record?.requestId ?? '';
    returnData = await repository.validasiPinEmail(event.record);

    debugPrint("onValidasiPinEmail returnData: ${returnData.data}");

    hasFailure = !returnData.success;
    emit(state.copyWith(
      isLoading: false,
      isLoaded: true,
      hasFailure: hasFailure,
    ));

    if (!hasFailure && returnData.data.isNotEmpty) {
      
      List<String> info = returnData.data.split(";");
      Token token = Token.split(info[0], info[1]);

      UserRepository userRepository = UserRepository();

      User user = User(
        id: 0,
        username: info[0],
        email: event.record.email,
        token: token.token,
      );

      AppData.user = user;
      AppData.userToken = token.token!;

      if (state.isSimpanPassword) {
        userRepository.persistToken(userToken: token.token!);
      }

      authenticationBloc.add(UserAuthenticated(user: user));
    } else {
      List<String> errors = [];
      errors.add(returnData.data);
      emit(state.copyWith(verificationFailed: true, errors: errors));
    }
  }

  Future<void> onFieldSimpanPasswordChangedEvent(
      FieldSimpanPasswordChangedEvent event,
      Emitter<EmailVerificationState> emit) async {
    debugPrint(
        "onFieldSimpanPasswordChangedEvent event: ${event.isSimpanPassword}");
    emit(state.copyWith(isSimpanPassword: event.isSimpanPassword));

    debugPrint(
        "onFieldSimpanPasswordChangedEvent state: ${state.isSimpanPassword}");
  }
}
