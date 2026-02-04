
import 'package:joss_app/blocs/payment/dnrekap2inv_bloc.dart';
import 'package:joss_app/pages/payment/historybayar2cari_main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';

class HistorybayarCariTileWidget extends StatelessWidget {
	final DateTime invTgl;
	final String inv1Id;
	final int jmlPolis;
	final int nomor;
	final String status;
	final double totalBayar;
	final String stsInvId;

	const HistorybayarCariTileWidget(
			{super.key,
				required this.invTgl,
				required this.inv1Id,
				required this.jmlPolis,
				required this.nomor,
				required this.status,
				required this.totalBayar,
				required this.stsInvId
			});

	@override
	Widget build(BuildContext context) {
		return Card(
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(15),
				),
				color: Colors.white,
				margin: const EdgeInsets.symmetric(horizontal: 10),
				elevation: 2,
				clipBehavior: Clip.antiAliasWithSaveLayer,
				child: Container(
					alignment: Alignment.topLeft,
					padding: const EdgeInsets.all(15),
					child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text("invTgl",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										DateFormat("dd/MM/yyyy").format(invTgl),
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("inv1Id",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										inv1Id,
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("jmlPolis",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										NumberFormat("#,###").format(jmlPolis),
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("nomor",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										NumberFormat("#,###").format(nomor),
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("status",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										status,
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("stsInvId",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										stsInvId,
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("totalBayar",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										NumberFormat("#,###").format(totalBayar),
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								SizedBox(
									width: MediaQuery.of(context).size.width * 0.5,
									height: 60,
									child: Padding(
										padding: const EdgeInsets.only(top: 30.0),
										child: ElevatedButton(
											onPressed: () {
												Navigator.push(
													context,
													MaterialPageRoute(
															builder: (context) {

																return Historybayar2CariMainPage(inv1Id: inv1Id);

															}),
												);
											},
											child: const Text(
												'Detail Invoice',
												style: TextStyle(fontSize: 13.0),
											),
										),
									),
								),
								Container(height: 10),
								if (stsInvId == "10002")
									SizedBox(
										width: MediaQuery.of(context).size.width * 0.5,
										height: 60,
										child: Padding(
											padding: const EdgeInsets.only(top: 30.0),
											child: ElevatedButton(
												onPressed: () {
													context.read<DnRekap2invBloc>().add(
														CheckInvoiceStatusEvent(
															invoiceId: inv1Id,
														),
													);
												},
												child: const Text(
													'Lanjutkan Pembayaran',
													style: TextStyle(fontSize: 13.0),
												),
											),
										),
									),
							]),
				)
		);
	}
}
