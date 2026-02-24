// import 'package:joss_app/blocs/gen_regmv/regmv6form_bloc.dart';
// import 'package:joss_app/blocs/gen_regmv/regmv_upload_foto_acc_bloc.dart';
// import 'package:joss_app/blocs/gen_regmv/regmv_upload_foto_mobil_bloc.dart';
// import 'package:joss_app/blocs/gen_regmv/regmv_upload_stnk_bloc.dart';
// import 'package:joss_app/pages/gen_regmv/regmv2form_form.dart';
// import 'package:joss_app/pages/gen_regmv/regmv3form_form.dart';
// import 'package:joss_app/pages/gen_regmv/regmv4cari_list_widget.dart';
// import 'package:joss_app/pages/gen_regmv/regmv4form_form.dart';
// import 'package:joss_app/pages/gen_regmv/regmv5cari_list_widget.dart';
// import 'package:joss_app/pages/gen_regmv/regmv5form_form.dart';
// import 'package:joss_app/pages/gen_regmv/regmv6form_form.dart';
// import 'package:joss_app/pages/gen_regmv/regmv7cari_list_widget.dart';
// import 'package:joss_app/pages/gen_regmv/regmv7form_form.dart';
// import 'package:joss_app/pages/gen_regmv/regmv_upload_foto_acc_dialog.dart';
// import 'package:joss_app/pages/gen_regmv/regmv_upload_foto_mobil_dialog.dart';
// import 'package:joss_app/pages/gen_regmv/regmv_upload_stnk_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:joss_app/widgets/my_colors.dart';
// import 'package:joss_app/widgets/my_text.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../blocs/gen_regmv/regmv7cari_bloc.dart';
//
// class Regmv1ListTileWidget extends StatelessWidget {
// 	final String calmv1Id;
// 	final String regmv1Id;
// 	final String ttgAlamat;
// 	final String ttgNama;
//
// 	const Regmv1ListTileWidget(
// 			{super.key,
// 				required this.calmv1Id,
// 				required this.regmv1Id,
// 				required this.ttgAlamat,
// 				required this.ttgNama});
//
// 	@override
// 	Widget build(BuildContext context) {
// 		return Card(
// 				shape: RoundedRectangleBorder(
// 					borderRadius: BorderRadius.circular(15),
// 				),
// 				color: Colors.white,
// 				margin: const EdgeInsets.symmetric(horizontal: 10),
// 				elevation: 2,
// 				clipBehavior: Clip.antiAliasWithSaveLayer,
// 				child: Container(
// 					alignment: Alignment.topLeft,
// 					padding: const EdgeInsets.all(15),
// 					child: Column(
// 							crossAxisAlignment: CrossAxisAlignment.start,
// 							children: [
// 								Text("calmv1Id",
// 										style: MyText.bodyLarge(context)!
// 												.copyWith(color: MyColors.grey_40)),
// 								Container(height: 5),
// 								Text(
// 										calmv1Id,
// 										style: MyText.bodyLarge(context)!
// 												.copyWith(color: MyColors.grey_80)),
// 								Container(height: 10),
// 								Text("regmv1Id",
// 										style: MyText.bodyLarge(context)!
// 												.copyWith(color: MyColors.grey_40)),
// 								Container(height: 5),
// 								Text(
// 										regmv1Id,
// 										style: MyText.bodyLarge(context)!
// 												.copyWith(color: MyColors.grey_80)),
// 								Container(height: 10),
// 								Text("ttgAlamat",
// 										style: MyText.bodyLarge(context)!
// 												.copyWith(color: MyColors.grey_40)),
// 								Container(height: 5),
// 								Text(
// 										ttgAlamat,
// 										style: MyText.bodyLarge(context)!
// 												.copyWith(color: MyColors.grey_80)),
// 								Container(height: 10),
// 								Text("ttgNama",
// 										style: MyText.bodyLarge(context)!
// 												.copyWith(color: MyColors.grey_40)),
// 								Container(height: 5),
// 								Text(
// 										ttgNama,
// 										style: MyText.bodyLarge(context)!
// 												.copyWith(color: MyColors.grey_80)),
// 								Container(height: 10),
// 								Row(
// 									mainAxisAlignment: MainAxisAlignment.spaceAround,
// 									children: [
// 										SizedBox(
// 											width: MediaQuery.of(context).size.width * 0.25,
// 											height: 80,
// 											child: Padding(
// 												padding: const EdgeInsets.only(top: 30.0),
// 												child: ElevatedButton(
// 													onPressed: () {
// 														showDialogRegMv2ViewData(context, 'ubah', regmv1Id);
// 													},
// 													child: const Text(
// 														'RegMV2',
// 														style: TextStyle(fontSize: 13.0),
// 													),
// 												),
// 											),
// 										),
// 										SizedBox(
// 											width: MediaQuery.of(context).size.width * 0.25,
// 											height: 80,
// 											child: Padding(
// 												padding: const EdgeInsets.only(top: 30.0),
// 												child: ElevatedButton(
// 													onPressed: () {
// 														showDialogRegMv3ViewData(context, 'ubah', regmv1Id);
// 													},
// 													child: const Text(
// 														'RegMV3',
// 														style: TextStyle(fontSize: 13.0),
// 													),
// 												),
// 											),
// 										),
// 										SizedBox(
// 											width: MediaQuery.of(context).size.width * 0.25,
// 											height: 100,
// 											child: Padding(
// 												padding: const EdgeInsets.only(top: 30.0),
// 												child: ElevatedButton(
// 													onPressed: () {
// 														//showDialogRegMv4ViewData(context, 'ubah', calmv1Id);
//
// 														showDialog(
// 															context: context,
// 															builder: (_) => BlocProvider.value(
// 																value: context.read<RegmvUploadStnkBloc>(),
// 																child: RegmvUploadStnkDialog(regmv1Id: regmv1Id),
// 															),
// 														);
// 													},
// 													child: const Text(
// 														'Upload STNK',
// 														style: TextStyle(fontSize: 13.0),
// 													),
// 												),
// 											),
// 										),
// 									],
// 								),
//
// 								Row(
// 									mainAxisAlignment: MainAxisAlignment.spaceAround,
// 									children: [
// 										SizedBox(
// 											width: MediaQuery.of(context).size.width * 0.25,
// 											height: 80,
// 											child: Padding(
// 												padding: const EdgeInsets.only(top: 30.0),
// 												child: ElevatedButton(
// 													onPressed: () {
// 														showDialogRegMv4ViewFotoData(context, regmv1Id);
// 													},
// 													child: const Text(
// 														'View Foto STNK',
// 														style: TextStyle(fontSize: 13.0),
// 													),
// 												),
// 											),
// 										),
// 										SizedBox(
// 											width: MediaQuery.of(context).size.width * 0.25,
// 											height: 100,
// 											child: Padding(
// 												padding: const EdgeInsets.only(top: 30.0),
// 												child: ElevatedButton(
// 													onPressed: () {
//
// 														showDialog(
// 															context: context,
// 															builder: (_) => BlocProvider.value(
// 																value: context.read<RegmvUploadFotoMobilBloc>(),
// 																child: RegmvUploadFotoMobilDialog(regmv1Id: regmv1Id),
// 															),
// 														);
// 													},
// 													child: const Text(
// 														'Upload Foto Mobil',
// 														style: TextStyle(fontSize: 13.0),
// 													),
// 												),
// 											),
// 										),
//
// 										SizedBox(
// 											width: MediaQuery.of(context).size.width * 0.25,
// 											height: 100,
// 											child: Padding(
// 												padding: const EdgeInsets.only(top: 30.0),
// 												child: ElevatedButton(
// 													onPressed: () {
// 														showDialogRegMv5ViewFotoData(context, regmv1Id);
// 													},
// 													child: const Text(
// 														'View Foto Mobil',
// 														style: TextStyle(fontSize: 13.0),
// 													),
// 												),
// 											),
// 										),
// 									],
// 								),
// 								Container(height: 10),
// 								Row(
// 									mainAxisAlignment: MainAxisAlignment.spaceAround,
// 									children: [
//
// 										SizedBox(
// 											width: MediaQuery.of(context).size.width * 0.25,
// 											height: 100,
// 											child: Padding(
// 												padding: const EdgeInsets.only(top: 30.0),
// 												child: ElevatedButton(
// 													onPressed: () {
// 														showDialog(
// 															context: context,
// 															builder: (_) => BlocProvider.value(
// 																value: context.read<RegmvUploadFotoAccBloc>(),
// 																child: RegmvUploadFotoAccDialog(regmv1Id: regmv1Id),
// 															),
// 														);
// 													},
// 													child: const Text(
// 														'Upload Foto Acc',
// 														style: TextStyle(fontSize: 13.0),
// 													),
// 												),
// 											),
// 										),
//
// 										SizedBox(
// 											width: MediaQuery.of(context).size.width * 0.25,
// 											height: 100,
// 											child: Padding(
// 												padding: const EdgeInsets.only(top: 30.0),
// 												child: ElevatedButton(
// 													onPressed: () {
// 														showDialogRegMv7ViewFotoData(context, regmv1Id);
// 													},
// 													child: const Text(
// 														'View Foto Acc',
// 														style: TextStyle(fontSize: 13.0),
// 													),
// 												),
// 											),
// 										),
//
// 									],
// 								),
// 								Container(height: 10),
// 								Row(
// 									mainAxisAlignment: MainAxisAlignment.spaceAround,
// 									children: [
// 										SizedBox(
// 											width: MediaQuery.of(context).size.width * 0.25,
// 											height: 80,
// 											child: Padding(
// 												padding: const EdgeInsets.only(top: 30.0),
// 												child: ElevatedButton(
// 													onPressed: () {
// 														context.read<Regmv6FormBloc>().add(
// 																Regmv6FormHitungPremiEvent(regmv1Id: regmv1Id));
// 													},
// 													child: const Text(
// 														'Hitung Premi',
// 														style: TextStyle(fontSize: 13.0),
// 													),
// 												),
// 											),
// 										),
// 										SizedBox(
// 											width: MediaQuery.of(context).size.width * 0.25,
// 											height: 80,
// 											child: Padding(
// 												padding: const EdgeInsets.only(top: 30.0),
// 												child: ElevatedButton(
// 													onPressed: () {
// 														showDialogRegMv6ViewData(context, 'ubah', regmv1Id);
// 													},
// 													child: const Text(
// 														'Lihat Premi',
// 														style: TextStyle(fontSize: 13.0),
// 													),
// 												),
// 											),
// 										),
// 									],
// 								),
//
//
// 							]),
// 				)
// 		);
// 	}
//
// 	void showDialogRegMv2ViewData(BuildContext context, String viewMode, String recordId) {
// 		FocusScope.of(context).requestFocus(FocusNode());
// 		showDialog(
// 				context: context,
// 				barrierDismissible: false,
// 				builder: (BuildContext context) {
// 					return Regmv2FormFormPage(viewMode: viewMode, recordId: recordId);
// 				},
// 				useSafeArea: true);
// 	}
//
// 	void showDialogRegMv3ViewData(BuildContext context, String viewMode, String recordId) {
// 		FocusScope.of(context).requestFocus(FocusNode());
// 		showDialog(
// 				context: context,
// 				barrierDismissible: false,
// 				builder: (BuildContext context) {
// 					return Regmv3FormFormPage(viewMode: viewMode, recordId: recordId);
// 				},
// 				useSafeArea: true);
// 	}
//
//
// 	void showDialogRegMv4ViewData(BuildContext context, String viewMode, String recordId) {
// 		FocusScope.of(context).requestFocus(FocusNode());
// 		showDialog(
// 				context: context,
// 				barrierDismissible: false,
// 				builder: (BuildContext context) {
// 					return Regmv4FormFormPage(viewMode: viewMode, recordId: recordId);
// 				},
// 				useSafeArea: true);
// 	}
//
// 	void showDialogRegMv5ViewData(BuildContext context, String viewMode, String recordId) {
// 		FocusScope.of(context).requestFocus(FocusNode());
// 		showDialog(
// 				context: context,
// 				barrierDismissible: false,
// 				builder: (BuildContext context) {
// 					return Regmv5FormFormPage(viewMode: viewMode, recordId: recordId);
// 				},
// 				useSafeArea: true);
// 	}
//
//
// 	void showDialogRegMv6ViewData(BuildContext context, String viewMode, String recordId) {
// 		FocusScope.of(context).requestFocus(FocusNode());
// 		showDialog(
// 				context: context,
// 				barrierDismissible: false,
// 				builder: (BuildContext context) {
// 					return Regmv6FormFormPage(viewMode: viewMode, recordId: recordId);
// 				},
// 				useSafeArea: true);
// 	}
//
// 	void showDialogRegMv7ViewData(BuildContext context, String viewMode, String recordId) {
// 		FocusScope.of(context).requestFocus(FocusNode());
// 		showDialog(
// 				context: context,
// 				barrierDismissible: false,
// 				builder: (BuildContext context) {
// 					return Regmv7FormFormPage(viewMode: viewMode, recordId: recordId);
// 				},
// 				useSafeArea: true);
// 	}
//
// 	void showDialogRegMv4ViewFotoData(BuildContext context, String recordId) {
// 		FocusScope.of(context).requestFocus(FocusNode());
// 		showDialog(
// 				context: context,
// 				barrierDismissible: true,
// 				builder: (BuildContext context) {
// 					return AlertDialog(
// 						shape: RoundedRectangleBorder(
// 							borderRadius: BorderRadius.circular(15),
// 						),
// 						backgroundColor: Colors.white,   // <-- membuat dialog tidak transparan
// 						title: Row(
// 							mainAxisAlignment: MainAxisAlignment.spaceBetween,
// 							children: [
// 								const Text("Daftar Foto STNK"),
// 								IconButton(
// 									icon: const Icon(Icons.close),
// 									onPressed: () => Navigator.of(context).pop(),
// 								),
// 							],
// 						),
// 						content: SizedBox(
// 							width: double.maxFinite,
// 							height: 400,
// 							child: Regmv4CariListWidget(
// 								regmv1Id: recordId,
// 							),
// 						),
// 					);
// 				},
// 				useSafeArea: true);
// 	}
//
// 	void showDialogRegMv5ViewFotoData(BuildContext context, String recordId) {
// 		FocusScope.of(context).requestFocus(FocusNode());
// 		showDialog(
// 				context: context,
// 				barrierDismissible: true,
// 				builder: (BuildContext context) {
// 					return AlertDialog(
// 						shape: RoundedRectangleBorder(
// 							borderRadius: BorderRadius.circular(15),
// 						),
// 						backgroundColor: Colors.white,   // <-- membuat dialog tidak transparan
// 						title: Row(
// 							mainAxisAlignment: MainAxisAlignment.spaceBetween,
// 							children: [
// 								const Text("Daftar Foto Mobil"),
// 								IconButton(
// 									icon: const Icon(Icons.close),
// 									onPressed: () => Navigator.of(context).pop(),
// 								),
// 							],
// 						),
// 						content: SizedBox(
// 							width: double.maxFinite,
// 							height: 400,                    // ⬅ agar dialog punya tinggi tetap
// 							child: Regmv5CariListWidget(
// 								regmv1Id: recordId,
// 							),
// 						),
// 					);
// 				},
// 				useSafeArea: true);
// 	}
//
// 	void showDialogRegMv7ViewFotoData(BuildContext context, String recordId) {
// 		FocusScope.of(context).requestFocus(FocusNode());
// 		context.read<Regmv7CariBloc>().add(Regmv7CariResetEvent());
// 		showDialog(
// 				context: context,
// 				barrierDismissible: false,
// 				builder: (BuildContext context) {
// 					return AlertDialog(
// 						shape: RoundedRectangleBorder(
// 							borderRadius: BorderRadius.circular(15),
// 						),
// 						backgroundColor: Colors.white,   // <-- membuat dialog tidak transparan
// 						title: Row(
// 							mainAxisAlignment: MainAxisAlignment.spaceBetween,
// 							children: [
// 								const Text("Daftar Foto Acc"),
// 								IconButton(
// 									icon: const Icon(Icons.close),
// 									onPressed: () => Navigator.of(context).pop(),
// 								),
// 							],
// 						),
// 						content: SizedBox(
// 							width: double.maxFinite,
// 							height: 400,                    // ⬅ agar dialog punya tinggi tetap
// 							child: Regmv7CariListWidget(
// 								regmv1Id: recordId,
// 							),
// 						),
// 					);
// 				},
// 				useSafeArea: true);
// 	}
//
// }
