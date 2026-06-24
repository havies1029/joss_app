part of 'invbayarvaform_bloc.dart';

abstract class InvbayarvaFormEvents extends Equatable {
  const InvbayarvaFormEvents();
  @override
  List<Object?> get props => [];
}

class InvbayarvaPollingStarted extends InvbayarvaFormEvents {
  final String invoiceId;
  final Duration interval;

  const InvbayarvaPollingStarted({
    required this.invoiceId,
    this.interval = const Duration(seconds: 3),
  });

  @override
  List<Object?> get props => [invoiceId, interval];
}

class InvbayarvaPollingStopped extends InvbayarvaFormEvents {
  const InvbayarvaPollingStopped();
}

// internal events
class _VaPollingTick extends InvbayarvaFormEvents {
  final String invoiceId;
  const _VaPollingTick({required this.invoiceId});

  @override
  List<Object?> get props => [invoiceId];
}

class _StatusPollingTick extends InvbayarvaFormEvents {
  final String invoiceId;
  const _StatusPollingTick({required this.invoiceId});

  @override
  List<Object?> get props => [invoiceId];
}

class InvoiceStatusPollingStarted extends InvbayarvaFormEvents {
  final String invoiceId;
  final Duration interval;

  const InvoiceStatusPollingStarted({
    required this.invoiceId,
    this.interval = const Duration(seconds: 10),
  });

  @override
  List<Object?> get props => [invoiceId, interval];
}

class CreditCardPaymentCheckingStarted extends InvbayarvaFormEvents {
  final String invoiceId;
  final Duration interval;

  const CreditCardPaymentCheckingStarted({
    required this.invoiceId,
    this.interval = const Duration(seconds: 5),
  });

  @override
  List<Object?> get props => [invoiceId, interval];
}