import 'package:equatable/equatable.dart';

class RegUserProfileState extends Equatable {
  final String email;
  final String reguserId;

  const RegUserProfileState({
    this.email = '',
    this.reguserId = '',
  });

  RegUserProfileState copyWith({
    String? email,
    String? reguserId,
  }) {
    return RegUserProfileState(
      email: email ?? this.email,
      reguserId: reguserId?? this.reguserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'reguserId': reguserId,
    };
  }

  factory RegUserProfileState.fromJson(Map<String, dynamic> json) {
    return RegUserProfileState(
      email: json['email'] ?? '',
      reguserId: json['reguserId'] ?? ''
    );
  }

  @override
  List<Object?> get props => [email, reguserId];
}
