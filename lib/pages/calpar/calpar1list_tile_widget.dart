import 'package:joss_app/blocs/authentication/authentication_bloc.dart';
import 'package:joss_app/blocs/calpar/calpar1list_bloc.dart';
import 'package:joss_app/blocs/calpar/calpar4form_bloc.dart';
import 'package:joss_app/models/user/user_model.dart';
import 'package:joss_app/pages/calpar/calpar2form_form.dart';
import 'package:joss_app/pages/calpar/calpar3form_form.dart';
import 'package:joss_app/pages/calpar/calpar4form_form.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';

class Calpar1ListTileWidget extends StatelessWidget {
	final String calpar1Id;
	final int coverBulan;
	final String kelasNama;
	final String okupasiDesc;

	const Calpar1ListTileWidget(
		{super.key,
		required this.calpar1Id, 
		required this.coverBulan, 
		required this.kelasNama, 
		required this.okupasiDesc});

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
						Text("calpar1Id",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							calpar1Id,
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
						Text("kelasNama",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							kelasNama,
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
						Container(height: 10),
						Text("okupasiDesc",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							okupasiDesc,
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
						Container(height: 10),

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
												showDialogCalPar2ViewData(context, 'ubah', calpar1Id);
											},
											child: const Text(
												'CalPar2',
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
												showDialogCalPar3ViewData(context, 'ubah', calpar1Id);
											},
											child: const Text(
												'CalPar3',
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
												showDialogCalPar4ViewData(context, 'ubah', calpar1Id);
											},
											child: const Text(
												'CalPar4',
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
												context.read<Calpar4FormBloc>().add(
												  Calpar4FormHitungPremiEvent(calpar1Id: calpar1Id));
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
												
                        if (context.read<AuthenticationBloc>().state is AuthenticationAuthenticated) {
                          User user = (context.read<AuthenticationBloc>().state as AuthenticationAuthenticated).user; 
                          if (user.userType == "C"){
                            context.read<Calpar1ListBloc>().add(
												      CalPar2RegParEvent(calpar1Id: calpar1Id));
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Only Client user can perform this action.'),
                              ),
                            );
                            context
                                .read<AuthenticationBloc>()
                                .add(RequireRegisterClient(requiredFrom: 'calmv1list_tile_widget'));
                          }
                        }

											},
											child: const Text(
												'CalPar to RegPar',
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

  void showDialogCalPar2ViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return Calpar2FormFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true);
  }

  void showDialogCalPar3ViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return Calpar3FormFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true);
  }

   void showDialogCalPar4ViewData(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return Calpar4FormFormPage(viewMode: viewMode, recordId: recordId);
			},
			useSafeArea: true);
  }


}
