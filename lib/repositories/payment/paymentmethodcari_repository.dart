import 'package:joss_app/apis/payment/paymentmethodcari_api.dart';
import 'package:joss_app/models/payment/paymentmethodcategory_model.dart';

class PaymentMethodCariRepository {
  final PaymentMethodCariAPI api;

  PaymentMethodCariRepository({required this.api});

  Future<List<PaymentCategory>> fetchPaymentMethods() async {
    return await api.getPaymentMethods();
  }
}