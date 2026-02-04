import 'package:joss_app/blocs/payment/dnrekap2inv_bloc.dart';
import 'package:joss_app/pages/payment/invbayarvaform_form.dart';
import 'package:joss_app/pages/payment/paymentmethodcari_list.dart';
import 'package:joss_app/pages/payment/paymentsuccess_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/payment/historybayarcari_bloc.dart';
import 'package:joss_app/pages/payment/historybayarcari_list_widget.dart';

class HistorybayarCariPage extends StatefulWidget {
	const HistorybayarCariPage({super.key});

	@override
	HistorybayarCariPageState createState() => HistorybayarCariPageState();
}

class HistorybayarCariPageState extends State<HistorybayarCariPage> {
	late HistorybayarCariBloc historybayarCariBloc;
	final TextEditingController _searchController = TextEditingController();
	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			refreshData();
		});
	}

	@override
	Widget build(BuildContext context) {
		historybayarCariBloc = BlocProvider.of<HistorybayarCariBloc>(context);
		return MultiBlocListener(
			listeners: [
				BlocListener<DnRekap2invBloc, DnRekap2invState>(
						listener: (context, state) {
							if (state.isProcessed){
								if (state.paymentStatus == "20"){
									ScaffoldMessenger.of(context).showSnackBar(
										const SnackBar(content: Text('Proses pembayaran berhasil. Silakan lanjutkan ke metode pembayaran.')),
									);
									onViewPaymentMethods(state.curr, state.totalBayar);
								}
								else if (state.paymentStatus == "30"){
									refreshData();
									ScaffoldMessenger.of(context).showSnackBar(
										const SnackBar(content: Text('Silakan lakukan pembayaran.')),
									);
									Navigator.push(
										context,
										MaterialPageRoute(
												builder: (context) => InvbayarvaFormFormPage(viewMode: "ubah", recordId: state.invoiceId)),
									);
								}
								else if (state.paymentStatus == "40"){
									ScaffoldMessenger.of(context).showSnackBar(
										const SnackBar(content: Text('Proses pembayaran Berhasil.')),
									);
									Navigator.push(
										context,
										MaterialPageRoute(
												builder: (context) => PaymentsuccessFormPage()),
									);
								}
								else if (state.paymentStatus == "91"){
									refreshData();
									ScaffoldMessenger.of(context).showSnackBar(
										const SnackBar(content: Text('Proses pembayaran gagal. Silakan coba lagi.')),
									);
								}
							}
						},
						listenWhen: (previous, current) {
							return previous.isProcessed != current.isProcessed ||
									previous.hasFailure != current.hasFailure;
						}),
			],
			child: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					children: [
						ListPageFilterBarUIWidget(
								searchController: _searchController,
								searchButton: buildSearchButton()),
						buildList()
					],

				),
			),
		);
	}
	void refreshData() {
		historybayarCariBloc.add(
				RefreshHistorybayarCariEvent(statusId: '10001', searchText: _searchController.text));
	}

	IconButton buildSearchButton() {
		return IconButton(
				icon: const Icon(
					Icons.autorenew_rounded,
					size: 35.0,
				),
				onPressed: () {
					historybayarCariBloc.add(RefreshHistorybayarCariEvent(statusId: '10001',
							searchText: _searchController.text));
				});
	}

	Widget buildList() {
		return Expanded(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					children: <Widget>[HistorybayarCariListWidget()],
				));
	}

	void onViewPaymentMethods(String curr, double totalBayar) {
		Navigator.push(
			context,
			MaterialPageRoute(builder: (context) => PaymentMethodsCariListPage(curr: curr, totalBayar: totalBayar)),
		); // Implement your ta
	}

}
