part of 'dnrekap2inv_bloc.dart';

abstract class DnRekap2invEvent extends Equatable {
	const DnRekap2invEvent();

	@override
	List<Object> get props => [];
}


class DnToInvByListCobProcessEvent extends DnRekap2invEvent {
  final String listCob;

  const DnToInvByListCobProcessEvent({required this.listCob});

  @override
  List<Object> get props => [listCob];
}

class DnToInvByListDnProcessEvent extends DnRekap2invEvent {
  final String listDn;

  const DnToInvByListDnProcessEvent({required this.listDn});

  @override
  List<Object> get props => [listDn];
}

class CheckInvoiceStatusEvent extends DnRekap2invEvent {
  final String invoiceId;

  const CheckInvoiceStatusEvent({required this.invoiceId});

  @override
  List<Object> get props => [invoiceId];
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