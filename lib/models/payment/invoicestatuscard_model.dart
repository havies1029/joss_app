class InvoiceStatusCards {
  String invoiceId;
  String status;
  double totalBayar;
  String curr;
  String redirectUrl;

  InvoiceStatusCards({
    required this.invoiceId,
    required this.status,
    required this.totalBayar,
    required this.curr,
    required this.redirectUrl,
  });

  factory InvoiceStatusCards.fromJson(Map<String, dynamic> data) {
    return InvoiceStatusCards(
      invoiceId: data['invoiceId'] ?? '',
      status: data['status'] ?? '',
      totalBayar: double.tryParse(data['totalBayar'].toString()) ?? 0,
      curr: data['curr'] ?? '',
      redirectUrl: data['redirect_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'invoiceId': invoiceId,
    'status': status,
    'totalBayar': totalBayar,
    'curr': curr,
    'redirect_url': redirectUrl,
  };

  factory InvoiceStatusCards.empty() {
    return InvoiceStatusCards(
      invoiceId: '',
      status: '',
      totalBayar: 0,
      curr: '',
      redirectUrl: '',
    );
  }

  InvoiceStatusCards copyWith({
    String? invoiceId,
    String? status,
    double? totalBayar,
    String? curr,
    String? redirectUrl,
  }) {
    return InvoiceStatusCards(
      invoiceId: invoiceId ?? this.invoiceId,
      status: status ?? this.status,
      totalBayar: totalBayar ?? this.totalBayar,
      curr: curr ?? this.curr,
      redirectUrl: redirectUrl ?? this.redirectUrl,
    );
  }
}