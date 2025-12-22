import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/models/reguser/reguser_model.dart';
import 'package:joss_app/repositories/reguser/reguser_repository.dart';

part 'reguser_event.dart';
part 'reguser_state.dart';

class RegUserBloc extends Bloc<RegUserEvents, RegUserState> {
	final RegUserRepository repository;
  final AuthenticationBloc authenticationBloc;
	RegUserBloc({required this.repository, 
    required this.authenticationBloc}) : super(const RegUserState()) {
		on<RegUserTambahEvent>(onTambahRegUser);
    on<RegUserUbahEvent>(onUbahRegUser);
    on<RegUserHapusEvent>(onHapusRegUser);
    on<RegUserLihatEvent>(onLihatRegUser);
    on<ValidasiPinHPEvent>(onValidasiPinHP);
	}

  Future<void> onTambahRegUser(
      RegUserTambahEvent event, Emitter<RegUserState> emit) async {
    ReturnDataAPI returnData;
    bool hasFailure = true;
    emit(state.copyWith(isSaving: true, isSaved: false));
    returnData = await repository.regUserTambah(event.record);
    final String dataString = returnData.data.toString();
    List<String> info = dataString.split(';');
    event.record.reguserId = info.isNotEmpty ? info[0] : '';
    hasFailure = !returnData.success;
    List<String> errors = [];
    if (hasFailure) {
      errors.add(returnData.data);
    }
    emit(state.copyWith(
        isSaving: false,
        isSaved: true,
        record: event.record,
        errors: errors,
        hasFailure: hasFailure));

    if (!hasFailure) {
      if (info[1] == '0') {
        authenticationBloc
            .add(RequirePinHPVerification(hpno: event.record.telepon));
      }
    }
  }

	Future<void> onUbahRegUser(
		RegUserUbahEvent event, Emitter<RegUserState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regUserUbah(event.record);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onHapusRegUser(
		RegUserHapusEvent event, Emitter<RegUserState> emit) async {
		emit(state.copyWith(isSaving: true, isSaved: false));
		bool hasFailure = !await repository.regUserHapus(event.recordId);
		emit(state.copyWith(isSaving: false, isSaved: true, hasFailure: hasFailure));
	}

	Future<void> onLihatRegUser(
		RegUserLihatEvent event, Emitter<RegUserState> emit) async {
		emit(state.copyWith(isLoading: true, isLoaded: false));
		RegUserModel record = await repository.regUserLihat(event.recordId);
		emit(state.copyWith(isLoading: false, isLoaded: true, record: record));
	}

  Future<void> onValidasiPinHP(
    ValidasiPinHPEvent event, Emitter<RegUserState> emit) async {
    emit(state.copyWith(isSaving: true, isSaved: false));
    ReturnDataAPI returnData = await repository.validasiPinHP(event.record);
    bool hasFailure = !returnData.success;
    List<String> errors = [];
    if (hasFailure) {
      errors.add(returnData.data);
    }
    emit(state.copyWith(
      isSaving: false,
      isSaved: true,
      hasFailure: hasFailure,
      verificationFailed: hasFailure,
      errors: errors,
    ));

    if (!hasFailure) {
      authenticationBloc.add(
        PhonePinVerified()
      );
    }
  }

}