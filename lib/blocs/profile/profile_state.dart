part of 'profile_bloc.dart';

class UserState {
  User? user;
  bool isLoading;
  bool isLoaded;
  bool isDeleting;
  bool isDeleted;
  bool isSaved;
  bool hasFailure;
  bool isSaving;

  UserState({
    this.user,
    this.isLoading = false,
    this.isSaved = false,
    this.isDeleting = false,
    this.isDeleted = false,
    this.isSaving = false,
    this.hasFailure = false,
    this.isLoaded = false,
  });
}
