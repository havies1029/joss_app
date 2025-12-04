import 'package:joss_app/blocs/regpar/regpar5form_bloc.dart';
import 'package:joss_app/pages/regpar/regpar2form_form.dart';
import 'package:joss_app/pages/regpar/regpar3form_form.dart';
import 'package:joss_app/pages/regpar/regpar4form_form.dart';
import 'package:joss_app/pages/regpar/regpar5form_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';

class Regpar1ListTileWidget extends StatelessWidget {
	final String regpar1Id;
	final String ttgAlamat;
	final String ttgNama;

	const Regpar1ListTileWidget(
			{super.key,
				required this.regpar1Id,
				required this.ttgAlamat,
				required this.ttgNama});

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
								Text("regpar1Id",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										regpar1Id,
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("ttgAlamat",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										ttgAlamat,
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_80)),
								Container(height: 10),
								Text("ttgNama",
										style: MyText.bodyLarge(context)!
												.copyWith(color: MyColors.grey_40)),
								Container(height: 5),
								Text(
										ttgNama,
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
														showDialogRegPar2ViewData(context, 'ubah', regpar1Id);
													},
													child: const Text(
														'RegPar2',
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
														showDialogRegPar3ViewData(context, 'ubah', regpar1Id);
													},
													child: const Text(
														'RegPar3',
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
														showDialogRegPar4ViewData(context, 'ubah', regpar1Id);
													},
													child: const Text(
														'RegPar4',
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
														context.read<Regpar5FormBloc>().add(
																Regpar5FormHitungPremiEvent(recordId: regpar1Id));
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
														showDialogRegPar5ViewData(context, 'ubah', regpar1Id);
													},
													child: const Text(
														'RegPar5',
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

	void showDialogRegPar2ViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
				context: context,
				barrierDismissible: false,
				builder: (BuildContext context) {
					return Regpar2FormFormPage(viewMode: viewMode, recordId: recordId);
				},
				useSafeArea: true);
	}

	void showDialogRegPar3ViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
				context: context,
				barrierDismissible: false,
				builder: (BuildContext context) {
					return Regpar3FormFormPage(viewMode: viewMode, recordId: recordId);
				},
				useSafeArea: true);
	}

	void showDialogRegPar4ViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
				context: context,
				barrierDismissible: false,
				builder: (BuildContext context) {
					return Regpar4FormFormPage(viewMode: viewMode, recordId: recordId);
				},
				useSafeArea: true);
	}


	void showDialogRegPar5ViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
				context: context,
				barrierDismissible: false,
				builder: (BuildContext context) {
					return Regpar5FormFormPage(viewMode: viewMode, recordId: recordId);
				},
				useSafeArea: true);
	}

}