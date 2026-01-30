import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';

class Regendors2CariTileWidget extends StatelessWidget {
	final String regendors2Id;
	final String remarks;
	final DateTime tglStatus;

	const Regendors2CariTileWidget(
		{super.key,
		required this.regendors2Id, 
		required this.remarks, 
		required this.tglStatus});

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
						Text("regendors2Id",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							regendors2Id,
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
						Container(height: 10),
						Text("remarks",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							remarks,
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
						Container(height: 10),
						Text("tglStatus",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							DateFormat("dd/MM/yyyy").format(tglStatus),
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
						Container(height: 10),
				]),
			)
		);
	}
}
