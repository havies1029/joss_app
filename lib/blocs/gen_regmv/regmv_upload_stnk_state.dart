part of 'regmv_upload_stnk_bloc.dart';


class Regmv4UploadFotoObjectState extends Equatable {
  final List<Regmv4UploadModel> items;
  final String? toast;
  final bool isClearing;
  final bool uploadAllDone;
  final bool isUploadingAll;

  const Regmv4UploadFotoObjectState({
    this.items = const [],
    this.toast,
    this.isClearing = false,
    this.uploadAllDone = false,
    this.isUploadingAll = false,
  });

  Regmv4UploadFotoObjectState copyWith({
    List<Regmv4UploadModel>? items,
    String? toast,
    bool clearToast = false,
    bool? isClearing,
    bool? uploadAllDone,
    bool? isUploadingAll,
  }) {
    return Regmv4UploadFotoObjectState(
      items: items ?? this.items,
      toast: clearToast ? null : (toast ?? this.toast),
      isClearing: isClearing ?? this.isClearing,
      uploadAllDone: uploadAllDone ?? false, // auto reset
      isUploadingAll: isUploadingAll ?? this.isUploadingAll,
    );
  }

  @override
  List<Object?> get props => [items, toast, isClearing, uploadAllDone, isUploadingAll];
}