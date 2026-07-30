class ReguserOtpSendModel {
  final String target;
  final String requestFrom;

  const ReguserOtpSendModel({
    required this.target,
    required this.requestFrom,
  });

  Map<String, dynamic> toJson() {
    return {
      'target': target,
      'requestFrom': requestFrom,
    };
  }
}

class ReguserOtpValidateModel {
  final String requestId;
  final String target;
  final String requestFrom;
  final String pin;

  const ReguserOtpValidateModel({
    required this.requestId,
    required this.target,
    required this.requestFrom,
    required this.pin,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'target': target,
      'requestFrom': requestFrom,
      'pin': pin,
    };
  }
}

class ReguserOtpHpRequestModel {
  final String requestId;
  final String target;

  const ReguserOtpHpRequestModel({
    required this.requestId,
    required this.target,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'target': target,
    };
  }
}
