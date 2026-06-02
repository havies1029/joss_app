abstract class QuotationPdfEvent {}

class DownloadQuotationPdfEvent extends QuotationPdfEvent {
  DownloadQuotationPdfEvent({
    required this.quotationType,
    required this.quotationNo,
  });

  final String quotationType;
  final String quotationNo;
}