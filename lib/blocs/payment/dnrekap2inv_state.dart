part of 'dnrekap2inv_bloc.dart';

class DnRekap2invState extends Equatable {
  final String invoiceId;
  final String paymentStatus;
  final bool isProcessing;
  final bool isProcessed;
  final bool hasFailure;
  final RincianSOAModel rincianSOA;
  final List<String> selectedIds;
  final double totalBayar;
  final String curr;
  final bool silentPaymentMessage;
  final InvoiceStatusCheckSource statusCheckSource;

  DnRekap2invState({
    this.invoiceId = "",
    this.paymentStatus = "",
    this.isProcessing = false,
    this.isProcessed = false,
    this.hasFailure = false,
    RincianSOAModel? rincianSOA,
    this.selectedIds = const [],
    this.totalBayar = 0.0,
    this.curr = "",
    this.silentPaymentMessage = false,
    this.statusCheckSource = InvoiceStatusCheckSource.general,
  }) : rincianSOA = rincianSOA ?? RincianSOAModel(headers: [], grandtotal: []);

  factory DnRekap2invState.initial() {
    return DnRekap2invState();
  }

  DnRekap2invState copyWith({
    String? invoiceId,
    String? paymentStatus,
    bool? isProcessing,
    bool? isProcessed,
    bool? hasFailure,
    RincianSOAModel? rincianSOA,
    List<String>? selectedIds,
    double? totalBayar,
    String? curr,
    bool? silentPaymentMessage,
    InvoiceStatusCheckSource? statusCheckSource,
  }) {
    return DnRekap2invState(
      invoiceId: invoiceId ?? this.invoiceId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      isProcessing: isProcessing ?? this.isProcessing,
      isProcessed: isProcessed ?? this.isProcessed,
      hasFailure: hasFailure ?? this.hasFailure,
      rincianSOA: rincianSOA ?? this.rincianSOA,
      selectedIds: selectedIds ?? this.selectedIds,
      totalBayar: totalBayar ?? this.totalBayar,
      curr: curr ?? this.curr,
      silentPaymentMessage: silentPaymentMessage ?? this.silentPaymentMessage,
      statusCheckSource: statusCheckSource ?? this.statusCheckSource,
    );
  }

  @override
  List<Object> get props => [
    invoiceId,
    paymentStatus,
    isProcessing,
    isProcessed,
    hasFailure,
    rincianSOA,
    selectedIds,
    totalBayar,
    curr,
    silentPaymentMessage,
    statusCheckSource,
  ];
}
