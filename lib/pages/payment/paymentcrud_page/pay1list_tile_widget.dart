import 'package:joss_app/blocs/payment/pay2cari_bloc.dart';
import 'package:joss_app/pages/payment/paymentcrud_page/pay2cari_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';

class Pay1ListTileWidget extends StatelessWidget {
	final DateTime arTgl;
	final String ar1Id;
	final int sppaCount;
	final double totalOs;

	const Pay1ListTileWidget(
		{super.key,
		required this.arTgl, 
		required this.ar1Id, 
		required this.sppaCount, 
		required this.totalOs});

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
						Text("arTgl",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							DateFormat("dd/MM/yyyy").format(arTgl),
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
						Container(height: 10),
						Text("ar1Id",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							ar1Id,
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
						Container(height: 10),
						Text("sppaCount",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							NumberFormat("#,###").format(sppaCount),
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
						Container(height: 10),
						Text("totalOs",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							NumberFormat("#,###").format(totalOs),
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
						Container(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialogListPayDetail(context, 'VIEW', ar1Id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.grey_40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'View Details',
                    style: MyText.bodyLarge(context)!
                      .copyWith(color: Colors.white),
                  ),
                ),
              ],
            )
				]),
			)
		);
	}

  void showDialogListPayDetail(BuildContext context, String viewMode, String recordId) {
		FocusScope.of(context).requestFocus(FocusNode());
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: BlocProvider.value(
            value: context.read<Pay2CariBloc>(),
            child: Pay2CariPage(ar1Id: recordId)));
			},
			useSafeArea: true);
  }
}
