part of 'notif_email_setting_bloc.dart';

class NotifEmailSettingState extends Equatable {
  final bool isNotifEmail;
  final bool isLoading;
  final bool isSaving;
  final bool isSaved;
  final bool hasLoaded;
  final bool hasFailure;
  final String message;

  const NotifEmailSettingState({
    this.isNotifEmail = true,
    this.isLoading = false,
    this.isSaving = false,
    this.isSaved = false,
    this.hasLoaded = false,
    this.hasFailure = false,
    this.message = '',
  });

  NotifEmailSettingState copyWith({
    bool? isNotifEmail,
    bool? isLoading,
    bool? isSaving,
    bool? isSaved,
    bool? hasLoaded,
    bool? hasFailure,
    String? message,
  }) {
    return NotifEmailSettingState(
      isNotifEmail: isNotifEmail ?? this.isNotifEmail,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      hasFailure: hasFailure ?? this.hasFailure,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        isNotifEmail,
        isLoading,
        isSaving,
        isSaved,
        hasLoaded,
        hasFailure,
        message,
      ];
}
