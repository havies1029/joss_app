abstract class  QuotationPdfState {}

class QuotationPdfInitial extends QuotationPdfState {}

class QuotationPdfLoading extends QuotationPdfState {}

class QuotationPdfLoaded extends QuotationPdfState {
  QuotationPdfLoaded({
    required this.filePath,
    required this.fileName,
  });

  final String filePath;
  final String fileName;
}

class QuotationPdfError extends QuotationPdfState {
  QuotationPdfError({
    required this.message,
  });

  final String message;
}