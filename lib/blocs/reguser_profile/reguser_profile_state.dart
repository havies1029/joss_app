import 'package:equatable/equatable.dart';

class RegUserProfileState extends Equatable {
  final String email;

  const RegUserProfileState({
    this.email = '',
  });

  RegUserProfileState copyWith({
    String? email,

  }) {
    return RegUserProfileState(
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  factory RegUserProfileState.fromJson(Map<String, dynamic> json) {
    return RegUserProfileState(
      email: json['email'] ?? '',
    );
  }

  @override
  List<Object?> get props => [email];
}
