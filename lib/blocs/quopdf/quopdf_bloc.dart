import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/quopdf/quopdf_event.dart';
import 'package:joss_app/blocs/quopdf/quopdf_state.dart';

import '../../repositories/quopdf/quopdf_repository.dart';

class QuotationPdfBloc extends Bloc<QuotationPdfEvent, QuotationPdfState> {
  QuotationPdfBloc() : super(QuotationPdfInitial()) {
    on<DownloadQuotationPdfEvent>(_downloadQuotationPdf);
  }

  Future<void> _downloadQuotationPdf(
      DownloadQuotationPdfEvent event,
      Emitter<QuotationPdfState> emit,
      ) async {
    try {
      emit(QuotationPdfLoading());

      final repo = QuotationPdfRepository();

      final file = await repo.downloadQuotationPdf(
        event.quotationType,
        event.quotationNo,
      );

      emit(
        QuotationPdfLoaded(
          filePath: file.path,
          fileName: file.uri.pathSegments.last,
        ),
      );
    } catch (e) {
      emit(
        QuotationPdfError(
          message: e.toString(),
        ),
      );
    }
  }
}