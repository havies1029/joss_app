class PaymentCardModel {
  String invoiceId;
  String cardNumber;
  String expiryMonth;
  String expiryYear;
  String cvn;
  String cardholderFirstName;
  String cardholderLastName;
  String cardholderEmail;
  String cardholderPhoneNumber;

  PaymentCardModel({
    required this.invoiceId,
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvn,
    required this.cardholderFirstName,
    required this.cardholderLastName,
    required this.cardholderEmail,
    required this.cardholderPhoneNumber,
  });

  factory PaymentCardModel.fromJson(Map<String, dynamic> data) {
    return PaymentCardModel(
      invoiceId: data['invoiceId'] ?? '',
      cardNumber: data['cardNumber'] ?? '',
      expiryMonth: data['expiryMonth'] ?? '',
      expiryYear: data['expiryYear'] ?? '',
      cvn: data['cvn'] ?? '',
      cardholderFirstName: data['cardholderFirstName'] ?? '',
      cardholderLastName: data['cardholderLastName'] ?? '',
      cardholderEmail: data['cardholderEmail'] ?? '',
      cardholderPhoneNumber: data['cardholderPhoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'invoiceId': invoiceId,
    'cardNumber': cardNumber,
    'expiryMonth': expiryMonth,
    'expiryYear': expiryYear,
    'cvn': cvn,
    'cardholderFirstName': cardholderFirstName,
    'cardholderLastName': cardholderLastName,
    'cardholderEmail': cardholderEmail,
    'cardholderPhoneNumber': cardholderPhoneNumber,
  };

  PaymentCardModel copyWith({
    String? invoiceId,
    String? cardNumber,
    String? expiryMonth,
    String? expiryYear,
    String? cvn,
    String? cardholderFirstName,
    String? cardholderLastName,
    String? cardholderEmail,
    String? cardholderPhoneNumber,
  }) {
    return PaymentCardModel(
      invoiceId: invoiceId ?? this.invoiceId,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      cvn: cvn ?? this.cvn,
      cardholderFirstName:
      cardholderFirstName ?? this.cardholderFirstName,
      cardholderLastName:
      cardholderLastName ?? this.cardholderLastName,
      cardholderEmail:
      cardholderEmail ?? this.cardholderEmail,
      cardholderPhoneNumber:
      cardholderPhoneNumber ?? this.cardholderPhoneNumber,
    );
  }

  factory PaymentCardModel.empty() {
    return PaymentCardModel(
      invoiceId: '',
      cardNumber: '',
      expiryMonth: '',
      expiryYear: '',
      cvn: '',
      cardholderFirstName: '',
      cardholderLastName: '',
      cardholderEmail: '',
      cardholderPhoneNumber: '',
    );
  }
}