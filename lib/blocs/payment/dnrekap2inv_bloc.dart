
import 'package:joss_app/apis/payment/paymentdn_api.dart';
import 'package:joss_app/models/payment/dnheadercob_model.dart';
import 'package:joss_app/models/payment/invoicestatus_model.dart';
import 'package:joss_app/repositories/payment/paymentdn_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'dnrekap2inv_event.dart';
part 'dnrekap2inv_state.dart'; 

class DnRekap2invBloc extends Bloc<DnRekap2invEvent, DnRekap2invState> {
	DnRekap2invBloc() : super(const DnRekap2invState()) {
   
    on<DnToInvByListCobProcessEvent>(onDnToInvByListCobProcess);
    on<DnToInvByListDnProcessEvent>(onDnToInvByListDnProcess);
    on<CheckInvoiceStatusEvent>(onCheckInvoiceStatus);
    on<Invoice2PaymentViaVAEvent>(onInvoice2PaymentViaVA);
    on<GetRincianSOACustomerEvent>(onGetRincianSOACustomer);
    on<SelectDetailEvent>(onSelectDetail);
    on<UnselectDetailEvent>(onUnselectDetail); 
    on<InitializeDnRekap2invEvent>((event, emit) {
      emit(DnRekap2invState.initial());
    });
    on<ForcePaymentViaVaEvent>(onForcePaymentViaVa);
  }
		
  Future<void> onDnToInvByListCobProcess(
      DnToInvByListCobProcessEvent event, Emitter<DnRekap2invState> emit) async {
    emit(state.copyWith(isProcessing: true, isProcessed: false, hasFailure: false));

    try {

      PaymentDnAPI api = PaymentDnAPI();
      PaymentDnRepository repo = PaymentDnRepository(api: api);
      List<InvoiceStatusModel> invoiceStatus = await repo.fetchDnToInvByListCob(event.listCob);

      emit(state.copyWith(
        isProcessing: false,
        isProcessed: true,
        invoiceId: invoiceStatus[0].invoiceId,
        paymentStatus: invoiceStatus[0].status,
      ));
    } catch (e) {
      emit(state.copyWith(
        isProcessing: false,
        hasFailure: true,
      ));
    }
  }

  Future<void>  onDnToInvByListDnProcess(
      DnToInvByListDnProcessEvent event, Emitter<DnRekap2invState> emit) async {
    emit(state.copyWith(isProcessing: true, isProcessed: false, hasFailure: false));

    try {

      PaymentDnAPI api = PaymentDnAPI();
      PaymentDnRepository repo = PaymentDnRepository(api: api);
      List<InvoiceStatusModel> invoiceStatus = await repo.fetchDnToInvByListDn(event.listDn);

      emit(state.copyWith(
        isProcessing: false,
        isProcessed: true,
        invoiceId: invoiceStatus[0].invoiceId,
        paymentStatus: invoiceStatus[0].status,
      ));
    } catch (e) {
      emit(state.copyWith(
        isProcessing: false,
        hasFailure: true,
      ));
    }
  }

  Future<void> onCheckInvoiceStatus(
      CheckInvoiceStatusEvent event, Emitter<DnRekap2invState> emit) async {
    emit(state.copyWith(isProcessing: true, isProcessed: false, hasFailure: false));

    try {

      PaymentDnAPI api = PaymentDnAPI();
      PaymentDnRepository repo = PaymentDnRepository(api: api);
      List<InvoiceStatusModel> invoiceStatus = await repo.fetchInvoiceStatus(event.invoiceId);

      emit(state.copyWith(
        isProcessing: false,
        isProcessed: true,
        paymentStatus: invoiceStatus[0].status,
      ));
    } catch (e) {
      emit(state.copyWith(
        isProcessing: false,
        hasFailure: true,
      ));
    }
  }
	
  Future<void> onInvoice2PaymentViaVA(
      Invoice2PaymentViaVAEvent event, Emitter<DnRekap2invState> emit) async {
    emit(state.copyWith(isProcessing: true, isProcessed: false, hasFailure: false));

    try {

      PaymentDnAPI api = PaymentDnAPI();
      PaymentDnRepository repo = PaymentDnRepository(api: api);
      List<InvoiceStatusModel> invoiceStatus = await repo.processInvoiceToPaymentViaVa(event.invoiceId, event.methodId);

      emit(state.copyWith(
        isProcessing: false,
        isProcessed: true,
        paymentStatus: invoiceStatus[0].status,
      ));
    } catch (e) {
      emit(state.copyWith(
        isProcessing: false,
        hasFailure: true,
      ));
    }
  }

  Future<void> onGetRincianSOACustomer(
      GetRincianSOACustomerEvent event, Emitter<DnRekap2invState> emit) async {
    debugPrint("onGetRincianSOACustomer called");
    emit(state.copyWith(isProcessing: true, isProcessed: false, hasFailure: false));

    try {

      PaymentDnAPI api = PaymentDnAPI();
      PaymentDnRepository repo = PaymentDnRepository(api: api);
      List<DnHeaderCobModel> rincianSOA = await repo.fetchRincianSOACustomer(event.searchText);

      emit(state.copyWith(
        isProcessing: false,
        isProcessed: true,
        rincianSOAList: rincianSOA,
      ));
    } catch (e) {
      emit(state.copyWith(
        isProcessing: false,
        hasFailure: true,
      ));
    }
  }

  Future<void> onSelectDetail(
      SelectDetailEvent event, Emitter<DnRekap2invState> emit) async {
    final updatedSelectedIds = List<String>.from(state.selectedIds)..add(event.dn1Id);
    emit(state.copyWith(selectedIds: updatedSelectedIds));
  }
  Future<void> onUnselectDetail(
      UnselectDetailEvent event, Emitter<DnRekap2invState> emit) async {
    final updatedSelectedIds = List<String>.from(state.selectedIds)..remove(event.dn1Id);
    emit(state.copyWith(selectedIds: updatedSelectedIds));
  }

  Future<void> onForcePaymentViaVa(
      ForcePaymentViaVaEvent event, Emitter<DnRekap2invState> emit) async {
    emit(state.copyWith(isProcessing: true, isProcessed: false, hasFailure: false));

    try {

      PaymentDnAPI api = PaymentDnAPI();
      PaymentDnRepository repo = PaymentDnRepository(api: api);
      await repo.forcePaymentViaVa(event.invoiceId);

      emit(state.copyWith(
        isProcessing: false,
        isProcessed: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isProcessing: false,
        hasFailure: true,
      ));
    }
  }

}