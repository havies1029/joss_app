class RegUserModel {
  String email;
  String? kodePin;
  String password;
  String personalNama;
  String? reguserId;
  String telepon;
  String userNama;
  String jnsClientId;

  RegUserModel({
    required this.email,
    this.kodePin,
    required this.password,
    required this.personalNama,
    this.reguserId,
    required this.telepon,
    required this.userNama,
    required this.jnsClientId,
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
      };
}
