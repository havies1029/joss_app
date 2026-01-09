
class InvoiceStatusModel {
	String invoiceId;
	String status;
  double totalBayar;

	InvoiceStatusModel({
		required this.invoiceId, required this.status, required this.totalBayar,});
	factory InvoiceStatusModel.fromJson(Map<String, dynamic> data) {
		return InvoiceStatusModel(
			invoiceId: data['invoiceId']??'',
			status: data['status']??'',
      totalBayar: data['totalBayar']??0.0,
		);

	}

	Map<String, dynamic> toJson() =>
		{'invoiceId': invoiceId,
		'status': status,
    'totalBayar': totalBayar,
    };

}
