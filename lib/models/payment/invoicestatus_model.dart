
class InvoiceStatusModel {
	String invoiceId;
	String status;

	InvoiceStatusModel({
		required this.invoiceId, required this.status});
	factory InvoiceStatusModel.fromJson(Map<String, dynamic> data) {
		return InvoiceStatusModel(
			invoiceId: data['invoiceId']??'',
			status: data['status']??'',
		);

	}

	Map<String, dynamic> toJson() =>
		{'invoiceId': invoiceId,
		'status': status};

}
