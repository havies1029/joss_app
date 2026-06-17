import 'package:joss_app/apis/payment/invoicestatuscard_api.dart';
import 'package:joss_app/models/payment/invoicestatuscard_model.dart';

class InvoiceStatusCardRepository {
  InvoiceStatusCardAPI api = InvoiceStatusCardAPI();

  Future<InvoiceStatusCards> invToBayarViaCard({
    required String invoiceId,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvn,
    required String cardholderFirstName,
    required String cardholderLastName,
  }) async {
    return await api.invToBayarViaCardAPI(
      invoiceId: invoiceId,
      cardNumber: cardNumber,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvn: cvn,
      cardholderFirstName: cardholderFirstName,
      cardholderLastName: cardholderLastName,
    );
  }
}