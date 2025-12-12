import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';

class DnrekapcobCariTileWidget extends StatelessWidget {
	final String cobId;
	final String cobNama;
	final String currId;
	final String currSimbol;
	final String dnrekapcobId;
	final double polisAmount;
	final int polisCount;
  final bool isChecked;
  final ValueChanged<bool?> onChecked;


	const DnrekapcobCariTileWidget(
		{super.key,
		required this.cobId, 
		required this.cobNama, 
		required this.currId, 
		required this.currSimbol, 
		required this.dnrekapcobId, 
		required this.polisAmount, 
		required this.polisCount,
    required this.isChecked,
    required this.onChecked});

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
            
            Row(
              children: [
                Checkbox(
                    value: isChecked,
                    onChanged: onChecked,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("cobId",
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_40)),
                      Container(height: 5),
                      Text(
                        cobId,
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_80)),
                      Container(height: 10),
                      Text("cobNama",
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_40)),
                      Container(height: 5),
                      Text(
                        cobNama,
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_80)),
                      Container(height: 10),
                      Text("currId",
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_40)),
                      Container(height: 5),
                      Text(
                        currId,
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_80)),
                      Container(height: 10),
                      Text("currSimbol",
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_40)),
                      Container(height: 5),
                      Text(
                        currSimbol,
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_80)),
                      Container(height: 10),                      
                      Text("polisAmount",
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_40)),
                      Container(height: 5),
                      Text(
                        NumberFormat("#,###").format(polisAmount),
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_80)),
                      Container(height: 10),
                      Text("polisCount",
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_40)),
                      Container(height: 5),
                      Text(
                        NumberFormat("#,###").format(polisCount),
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_80)),
                    ],
                  ),
              ],
            ),                        
            
				]),
			)
		);
	}
}
