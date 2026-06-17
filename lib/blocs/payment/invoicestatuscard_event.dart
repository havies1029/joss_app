part of 'invoicestatuscard_bloc.dart';

abstract class InvoiceStatusCardEvents extends Equatable {
  const InvoiceStatusCardEvents();

  @override
  List<Object> get props => [];
}

class InvToBayarViaCardEvent extends InvoiceStatusCardEvents {
  final String invoiceId;
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;
  final String cvn;
  final String cardholderFirstName;
  final String cardholderLastName;

  const InvToBayarViaCardEvent({
    required this.invoiceId,
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvn,
    required this.cardholderFirstName,
    required this.cardholderLastName,
  });

  @override
  List<Object> get props => [
    invoiceId,
    cardNumber,
    expiryMonth,
    expiryYear,
    cvn,
    cardholderFirstName,
    cardholderLastName,
  ];
}