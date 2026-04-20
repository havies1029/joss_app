class RegUserModel {
  String email;
  String? kodePin;
  String password;
  String personalNama;
  String? reguserId;
  String telepon;
  String userNama;
  String jnsClientId;
  String sendOtpVia;

  RegUserModel({
    required this.email,
    this.kodePin,
    required this.password,
    required this.personalNama,
    this.reguserId,
    required this.telepon,
    required this.userNama,
    required this.jnsClientId,
    required this.sendOtpVia,
  });

  factory RegUserModel.fromJson(Map<String, dynamic> data) {
    return RegUserModel(
      email: data['email'] ?? '',
      kodePin: data['kodePin'] ?? '',
      password: data['password'] ?? '',
      personalNama: data['personalNama'] ?? '',
      reguserId: data['reguserId'] ?? '',
      telepon: data['telepon'] ?? '',
      userNama: data['userNama'] ?? '',
      jnsClientId: data['jnsClientId'] ?? '',
      sendOtpVia: data['sendOtpVia'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'kodePin': kodePin,
        'password': password,
        'personalNama': personalNama,
        'reguserId': reguserId,
        'telepon': telepon,
        'userNama': userNama,
        'jnsClientId': jnsClientId,
        'sendOtpVia': sendOtpVia,
      };

  RegUserModel copyWith({
    String? email,
    String? kodePin,
    String? password,
    String? personalNama,
    String? reguserId,
    String? telepon,
    String? userNama,
    String? jnsClientId,
    String? sendOtpVia,
  }) {
    return RegUserModel(
      email: email ?? this.email,
      kodePin: kodePin ?? this.kodePin,
      password: password ?? this.password,
      personalNama: personalNama ?? this.personalNama,
      reguserId: reguserId ?? this.reguserId,
      telepon: telepon ?? this.telepon,
      userNama: userNama ?? this.userNama,
      jnsClientId: jnsClientId ?? this.jnsClientId,
      sendOtpVia: sendOtpVia ?? this.sendOtpVia,
    );
  }
}
