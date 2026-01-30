import 'package:joss_app/apis/payment/paymentdn_api.dart';
import 'package:joss_app/models/payment/invoicestatus_model.dart';
import 'package:joss_app/models/payment/paymentmethodcategory_model.dart';
import 'package:joss_app/models/payment/rinciansoa_model.dart';

class PaymentDnRepository {
  final PaymentDnAPI api;

  PaymentDnRepository({required this.api});

  Future<List<PaymentCategory>> fetchPaymentMethods() async {
    return await api.getPaymentMethods();
  }

  Future<List<InvoiceStatusModel>> fetchInvoiceStatus(String inv1Id) async {
    return await api.cekPaymentStatusAPI(inv1Id);
  }

  Future<List<InvoiceStatusModel>> fetchDnToInvByListCob(String listcob) async {
    return await api.dnToInvByListCobAPI(listcob);
  }

  Future<List<InvoiceStatusModel>> fetchDnToInvByListDn(String listdn) async {
    return await api.dnToInvByListDnAPI(listdn);
  }

  Future<List<InvoiceStatusModel>> processInvoiceToPaymentViaVa(String invoiceId, String methodId) async {
    return await api.invoice2PaymentViaVaAPI(invoiceId, methodId);
  }

  Future<RincianSOAModel> fetchRincianSOACustomer(String searchText) async {
    return await api.getRincianSOACustomer(searchText);
  }

  Future<bool> forcePaymentViaVa(String invoiceId) async {
    return await api.forcePaymentViaVaAPI(invoiceId);
  }

  Future<List<InvoiceStatusModel>> regMv2Inv(String regmv1Id) async {
    return await api.regMv2InvAPI(regmv1Id);
  }

  Future<List<InvoiceStatusModel>> regPar2Inv(String regpar1Id) async {
    return await api.regPar2InvAPI(regpar1Id);
  }


}