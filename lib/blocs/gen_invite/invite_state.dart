part of 'invite_bloc.dart';

class InviteState {
  final bool isLoading;
  final bool isSuccess;
  final String message;

  const InviteState({
    this.isLoading = false,
    this.isSuccess = false,
    this.message = '',
  });

  InviteState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
  }) {
    return InviteState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
    );
  }
}
