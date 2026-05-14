import 'package:flutter/material.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';

class Mlayanan1CariTileWidget extends StatelessWidget {
	final String descText;
	final String mlayanan1Id;
	final String titleText;

	const Mlayanan1CariTileWidget(
		{super.key,
		required this.descText, 
		required this.mlayanan1Id, 
		required this.titleText});

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
						Text("descText",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							descText,
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
						Container(height: 10),
						Text("mlayanan1Id",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							mlayanan1Id,
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
						Container(height: 10),
						Text("titleText",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							titleText,
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
						Container(height: 10),
				]),
			)
		);
	}
}
