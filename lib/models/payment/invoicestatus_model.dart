class InvoiceStatusModel {
  String invoiceId;
  String status;
  double totalBayar;
  String curr;

  InvoiceStatusModel({
    required this.invoiceId,
    required this.status,
    required this.totalBayar,
    required this.curr,
  });

  factory InvoiceStatusModel.fromJson(Map<String, dynamic> data) {
    return InvoiceStatusModel(
      invoiceId: data['invoiceId'] ?? '',
      status: data['status'] ?? '',
      totalBayar: double.tryParse(data['totalBayar'].toString()) ?? 0,
      curr: data['curr']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'invoiceId': invoiceId,
        'status': status,
        'totalBayar': totalBayar,
        'curr': curr,
      };
}
