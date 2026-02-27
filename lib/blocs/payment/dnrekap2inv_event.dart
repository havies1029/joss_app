part of 'dnrekap2inv_bloc.dart';

abstract class DnRekap2invEvent extends Equatable {
  const DnRekap2invEvent();

  @override
  List<Object> get props => [];
}


class DnToInvByListCobProcessEvent extends DnRekap2invEvent {
  final String listCob;
  final String? curr;

  const DnToInvByListCobProcessEvent({
    required this.listCob,
    this.curr,
  });

  @override
  List<Object> get props => [listCob, curr ?? ""];
}


class DnToInvByListDnProcessEvent extends DnRekap2invEvent {
  final String listDn;
  final String? curr;

  const DnToInvByListDnProcessEvent({
    required this.listDn,
    this.curr,
  });

  @override
  List<Object> get props => [listDn, curr ?? ""];
}

class CheckInvoiceStatusEvent extends DnRekap2invEvent {
  final String invoiceId;

  const CheckInvoiceStatusEvent({required this.invoiceId});

  @override
  List<Object> get props => [invoiceId];
}

class SetRecordInvoiceStatusEvent extends DnRekap2invEvent {
  final InvoiceStatusModel invoiceStatusRecord;

  const SetRecordInvoiceStatusEvent({required this.invoiceStatusRecord});

  @override
  List<Object> get props => [invoiceStatusRecord];
}

class Invoice2PaymentViaVAEvent extends DnRekap2invEvent {
  final String invoiceId;
  final String methodId;

  const Invoice2PaymentViaVAEvent({required this.invoiceId, required this.methodId});
  @override
  List<Object> get props => [invoiceId, methodId];
}

class GetRincianSOACustomerEvent extends DnRekap2invEvent {
  final String searchText;

  const GetRincianSOACustomerEvent({required this.searchText});

  @override
  List<Object> get props => [searchText];
}

class SelectDetailEvent extends DnRekap2invEvent {
  final String dn1Id;
  const SelectDetailEvent(this.dn1Id);
}

class UnselectDetailEvent extends DnRekap2invEvent {
  final String dn1Id;
  const UnselectDetailEvent(this.dn1Id);
}

class InitializeDnRekap2invEvent extends DnRekap2invEvent {}

class ForcePaymentViaVaEvent extends DnRekap2invEvent {
  final String invoiceId;

  const ForcePaymentViaVaEvent({required this.invoiceId});
  @override
  List<Object> get props => [invoiceId];
}

class RegMv2InvoiceEvent extends DnRekap2invEvent {
  final String regmv1Id;

  const RegMv2InvoiceEvent({required this.regmv1Id});

  @override
  List<Object> get props => [regmv1Id];
}

class RegPar2InvoiceEvent extends DnRekap2invEvent {
  final String regpar1Id;

  const RegPar2InvoiceEvent({required this.regpar1Id});

  @override
  List<Object> get props => [regpar1Id];
}

class SetPaymentSummaryEvent extends DnRekap2invEvent {
  final String curr;
  final double totalBayar;

  const SetPaymentSummaryEvent({
    required this.curr,
    required this.totalBayar,
  });

  @override
  List<Object> get props => [curr, totalBayar];
}
