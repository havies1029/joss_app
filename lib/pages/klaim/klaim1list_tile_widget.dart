import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';

class Klaim1ListTileWidget extends StatelessWidget {
	final String insuranceName;
	final String insuredName;
	final String kejadianLokasi;
	final DateTime kejadianTgl;
	final double klaimAmount;
	final String klaim1Id;
	final String currDesc;
	final String rugiDesc;
	final String statusNama;

	const Klaim1ListTileWidget(
		{super.key,
		required this.insuranceName, 
		required this.insuredName, 
		required this.kejadianLokasi, 
		required this.kejadianTgl, 
		required this.klaimAmount, 
		required this.klaim1Id, 
		required this.currDesc, 
		required this.rugiDesc, 
		required this.statusNama});

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
                Flexible(
                  flex: 1,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Klaim Id",
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_40)),
                      Container(height: 5),
                      Text(
                        klaim1Id,
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_80)),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tanggal",
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_40)),
                      Container(height: 5),
                      Text(
                        DateFormat("dd/MM/yyyy").format(kejadianTgl),
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_80)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),            
						Text("Jenis Asuransi",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							insuranceName,
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
            const SizedBox(height: 13), 
						Text("Nama Tertanggung",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							insuredName,
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
            const SizedBox(height: 13), 
						Text("Lokasi Kejadian",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							kejadianLokasi,
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
            const SizedBox(height: 13), 
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nilai Klaim",
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_40)),
                      Container(height: 5),
                      Text('$currDesc ${NumberFormat("#,###").format(klaimAmount)}',
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_80)),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Jenis Kerugian",
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_40)),
                      Container(height: 5),
                      Text(
                        rugiDesc,
                        style: MyText.bodyLarge(context)!
                          .copyWith(color: MyColors.grey_80)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13), 
						Text("Status Klaim",
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_40)),
						Container(height: 5),
						Text(
							statusNama,
							style: MyText.bodyLarge(context)!
								.copyWith(color: MyColors.grey_80)),
            const SizedBox(height: 10), 
				]),
			)
		);
	}
}
