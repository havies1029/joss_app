part of 'invoicestatuscard_bloc.dart';

class InvoiceStatusCardState extends Equatable {
  final InvoiceStatusCards? record;
  final bool isLoading;
  final bool isLoaded;
  final bool hasFailure;
  final String message;

  const InvoiceStatusCardState({
    this.record,
    this.isLoading = false,
    this.isLoaded = false,
    this.hasFailure = false,
    this.message = '',
  });

  static const _sentinel = Object();

  InvoiceStatusCardState copyWith({
    Object? record = _sentinel,
    bool? isLoading,
    bool? isLoaded,
    bool? hasFailure,
    String? message,
  }) {
    return InvoiceStatusCardState(
      record: identical(record, _sentinel)
          ? this.record
          : record as InvoiceStatusCards?,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      hasFailure: hasFailure ?? this.hasFailure,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    record,
    isLoading,
    isLoaded,
    hasFailure,
    message,
  ];
}