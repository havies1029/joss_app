import 'package:joss_app/models/responseAPI/returndataapi_model.dart';
import 'package:joss_app/apis/payment/invbayarvaform_api.dart';
import 'package:joss_app/models/payment/invbayarvaform_model.dart';

class InvbayarvaFormRepository {

	InvbayarvaFormAPI api = InvbayarvaFormAPI();

	Future<ReturnDataAPI> invbayarvaFormTambah(InvbayarvaFormModel record) async {
		return await api.invbayarvaFormTambahAPI(record);
	}
	Future<bool> invbayarvaFormUbah(InvbayarvaFormModel record) async {
		return await api.invbayarvaFormUbahAPI(record);
	}
	Future<bool> invbayarvaFormHapus(String invbayarvaId) async {
		return await api.invbayarvaFormHapusAPI(invbayarvaId);
	}
	Future<InvbayarvaFormModel> invbayarvaFormLihat(String invoiceId) async {
		return await api.invbayarvaFormLihatAPI(invoiceId);
	}
}
