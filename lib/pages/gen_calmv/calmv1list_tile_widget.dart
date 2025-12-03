import 'package:joss_app/blocs/gen_calmv/calmv1list_bloc.dart';
import 'package:joss_app/blocs/gen_calmv/calmv3form_bloc.dart';
import 'package:joss_app/pages/gen_calmv/calmv2form_form.dart';
import 'package:joss_app/pages/gen_calmv/calmv3form_form.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';

class Calmv1ListTileWidget extends StatelessWidget {
	final String calmv1Id;
	final int coverBulan;
	final String coverName;
	final String grupNama;
	final double harga;
	final String pakaiNama;
	final String rmatauangNama;
	final int thnBuat;
	final String wilayahNama;

	const Calmv1ListTileWidget(
			{super.key,
				required this.calmv1Id,
				required this.coverBulan,
				required this.coverName,
				required this.grupNama,
				required this.harga,
				required this.pakaiNama,
				required this.rmatauangNama,
				required this.thnBuat,
				required this.wilayahNama});

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
								Text("calmv1Id",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										calmv1Id,
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("coverBulan",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										NumberFormat("#,###").format(coverBulan),
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("coverName",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										coverName,
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("grupNama",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										grupNama,
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("harga",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										NumberFormat("#,###").format(harga),
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("pakaiNama",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										pakaiNama,
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("rmatauangNama",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										rmatauangNama,
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("thnBuat",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										NumberFormat("#,###").format(thnBuat),
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("wilayahNama",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										wilayahNama,
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Row(
									mainAxisAlignment: MainAxisAlignment.spaceAround,
									children: [
										SizedBox(
											width: MediaQuery.of(context).size.width * 0.25,
											height: 80,
											child: Padding(
												padding: const EdgeInsets.only(top: 30.0),
												child: ElevatedButton(
													onPressed: () {
														showDialogCalMv2ViewData(context, 'ubah', calmv1Id);
													},
													child: const Text(
														'CalMV2',
														style: TextStyle(fontSize: 13.0),
													),
												),
											),
										),
										SizedBox(
											width: MediaQuery.of(context).size.width * 0.25,
											height: 80,
											child: Padding(
												padding: const EdgeInsets.only(top: 30.0),
												child: ElevatedButton(
													onPressed: () {
														context.read<Calmv3FormBloc>().add(
																Calmv3FormHitungPremiEvent(calmv1Id: calmv1Id));
													},
													child: const Text(
														'Hitung Premi',
														style: TextStyle(fontSize: 13.0),
													),
												),
											),
										),
										SizedBox(
											width: MediaQuery.of(context).size.width * 0.25,
											height: 80,
											child: Padding(
												padding: const EdgeInsets.only(top: 30.0),
												child: ElevatedButton(
													onPressed: () {
														showDialogCalMv3ViewData(context, 'lihat', calmv1Id);
													},
													child: const Text(
														'CalMV3',
														style: TextStyle(fontSize: 13.0),
													),
												),
											),
										),
									],
								),

								Container(height: 10),
								Row(
									mainAxisAlignment: MainAxisAlignment.spaceAround,
									children: [
										SizedBox(
											width: MediaQuery.of(context).size.width * 0.25,
											height: 80,
											child: Padding(
												padding: const EdgeInsets.only(top: 30.0),
												child: ElevatedButton(
													onPressed: () {
														context.read<Calmv1ListBloc>().add(
																CalMv2RegMvEvent(calmv1Id: calmv1Id));
													},
													child: const Text(
														'Cal MV to Reg MV',
														style: TextStyle(fontSize: 13.0),
													),
												),
											),
										),
									],
								),

							]),
				)
		);
	}

	void showDialogCalMv2ViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
				context: context,
				barrierDismissible: false,
				builder: (BuildContext context) {
					return Calmv2FormFormPage(viewMode: viewMode, recordId: recordId);
				},
				useSafeArea: true);
	}

	void showDialogCalMv3ViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
				context: context,
				barrierDismissible: false,
				builder: (BuildContext context) {
					return Calmv3FormFormPage(viewMode: viewMode, recordId: recordId);
				},
				useSafeArea: true);
	}

}
