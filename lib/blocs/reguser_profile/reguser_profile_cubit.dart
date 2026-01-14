// import 'package:flutter/cupertino.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
// import '../../models/reguser/reguser_model.dart';
// import 'reguser_profile_state.dart';
//
// class RegUserProfileCubit extends HydratedCubit<RegUserProfileState> {
//   RegUserProfileCubit() : super(const RegUserProfileState());
//
//   // Set partial profile
//   void setProfile({
//     String? email,
//     String? reguserId,
//   }) {
//     emit(state.copyWith(
//       email: email,
//       reguserId: reguserId,
//     ));
//   }
//
//   // Isi profile langsung dari model
//   void setFromModel(RegUserModel model) {
//     emit(state.copyWith(
//       email: model.email,
//       reguserId: model.reguserId,
//     ));
//   }
//
//   void clearProfile() {
//     clear(); // hapus cache HydratedBl
//     debugPrint('[RegUserProfileCubit] CLEAR DIPANGGIL');// oc
//     emit(const RegUserProfileState());
//   }
//
//   @override
//   RegUserProfileState? fromJson(Map<String, dynamic> json) =>
//       RegUserProfileState.fromJson(json);
//
//   @override
//   Map<String, dynamic>? toJson(RegUserProfileState state) => state.toJson();
// }
