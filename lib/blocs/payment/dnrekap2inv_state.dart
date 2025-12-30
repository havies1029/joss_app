part of 'dnrekap2inv_bloc.dart';

class DnRekap2invState extends Equatable {

	final String invoiceId;
  final String paymentStatus;
	final bool isProcessing;
	final bool isProcessed;
	final bool hasFailure;
  final List<DnHeaderCobModel> rincianSOAList;
  final List<String> selectedIds;


	const DnRekap2invState(
		{this.invoiceId = "",
    this.paymentStatus = "",
		this.isProcessing = false,
		this.isProcessed = false,
		this.hasFailure = false,
    this.rincianSOAList = const [],
    this.selectedIds = const [],
    });

factory DnRekap2invState.initial() {
  return const DnRekap2invState(
    invoiceId: "",
    paymentStatus: "",
    isProcessing: false,
    isProcessed: false,
    hasFailure: false,
    rincianSOAList: [],
    selectedIds: [],
  );
}


	DnRekap2invState copyWith(
		{
      String? invoiceId,
      String? paymentStatus,
      bool? isProcessing,
      bool? isProcessed,
      bool? hasFailure,
      List<DnHeaderCobModel>? rincianSOAList,
      List<String>? selectedIds,
    }) {
		return DnRekap2invState(			
			invoiceId: invoiceId ?? this.invoiceId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      isProcessing: isProcessing ?? this.isProcessing,
      isProcessed: isProcessed ?? this.isProcessed,
      hasFailure: hasFailure ?? this.hasFailure,
      rincianSOAList: rincianSOAList ?? this.rincianSOAList,
      selectedIds: selectedIds ?? this.selectedIds,
    );
	}

	@override
	List<Object> get props => [invoiceId, paymentStatus, isProcessing, isProcessed, hasFailure, rincianSOAList, selectedIds];
}
