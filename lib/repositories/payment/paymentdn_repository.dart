import 'package:joss_app/apis/payment/paymentdn_api.dart';
import 'package:joss_app/models/payment/invoicestatus_model.dart';
import 'package:joss_app/models/payment/paymentmethodcategory_model.dart';
import 'package:joss_app/models/payment/rinciansoa_model.dart';

import '../../models/payment/paymentcard_model.dart';

class PaymentDnRepository {
  final PaymentDnAPI api;

  PaymentDnRepository({required this.api});

  Future<List<PaymentCategory>> fetchPaymentMethods() async {
    return await api.getPaymentMethods();
  }

  Future<InvoiceStatusModel> fetchInvoiceStatus(String inv1Id) async {
    return await api.cekPaymentStatusAPI(inv1Id);
  }

  Future<InvoiceStatusModel> fetchDnToInvByListCob(String listcob) async {
    return await api.dnToInvByListCobAPI(listcob);
  }

  Future<InvoiceStatusModel> fetchDnToInvByListDn(String listdn) async {
    return await api.dnToInvByListDnAPI(listdn);
  }

  Future<InvoiceStatusModel> processInvoiceToPaymentViaVa(String invoiceId, String methodId) async {
    return await api.invoice2PaymentViaVaAPI(invoiceId, methodId);
  }

  Future<InvoiceStatusModel> processInvoiceToPaymentViaCard(
      PaymentCardModel record,
      ) async {
    return await api.invoice2PaymentViaCardAPI(record);
  }

  Future<RincianSOAModel> fetchRincianSOACustomer(String searchText) async {
    return await api.getRincianSOACustomer(searchText);
  }

  Future<bool> forcePaymentViaVa(String invoiceId) async {
    return await api.forcePaymentViaVaAPI(invoiceId);
  }

  Future<InvoiceStatusModel> regMv2Inv(String regmv1Id) async {
    return await api.regMv2InvAPI(regmv1Id);
  }

  Future<InvoiceStatusModel> regPar2Inv(String regpar1Id) async {
    return await api.regPar2InvAPI(regpar1Id);
  }

  Future<InvoiceStatusModel> batalInvById(String invoiceId) async {
    return await api.batalInvByIdAPI(invoiceId);
  }
}