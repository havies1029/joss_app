class RequestOtpModel {
  String? requestOtpId;
  String sentTo;
  String? kodePin;
  String sentVia;
  String purpose;

  RequestOtpModel({required this.sentTo, this.kodePin, this.requestOtpId, required this.sentVia, required this.purpose});

  factory RequestOtpModel.fromJson(Map<String, dynamic> data) {
    return RequestOtpModel(
      sentTo: data['sentTo'] ?? '',
      kodePin: data['kodePin'] ?? '',
      requestOtpId: data['requestOtpId'] ?? '',
      sentVia: data['sentVia'] ?? '',
      purpose: data['purpose'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'sentTo': sentTo,
        'kodePin': kodePin,
        'requestOtpId': requestOtpId,
        'sentVia': sentVia,
        'purpose': purpose,
      };
}
