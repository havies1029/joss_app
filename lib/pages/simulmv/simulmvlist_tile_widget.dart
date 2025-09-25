import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';

class SimulmvListTileWidget extends StatelessWidget {
  final double aw;
  final int coverBulan;
  final String coverName;
  final String grupNama;
  final double harga;
  final bool isEq;
  final bool isFlood;
  final bool isSrcc;
  final bool isTerrorism;
  final double pad;
  final double pap;
  final String pARENTID;
  final DateTime periodeAkhir;
  final DateTime periodeMulai;
  final double pll;
  final double premiAdd;
  final double premiCasco;
  final double premiTotal;
  final String remarks;
  final String rMATAUANGNAMA;
  final String simulmv1Id;
  final String theinsured;
  final int thnBuat;
  final double tpl;
  final String wilayahNama;

  const SimulmvListTileWidget(
      {super.key,
      required this.aw,
      required this.coverBulan,
      required this.coverName,
      required this.grupNama,
      required this.harga,
      required this.isEq,
      required this.isFlood,
      required this.isSrcc,
      required this.isTerrorism,
      required this.pad,
      required this.pap,
      required this.pARENTID,
      required this.periodeAkhir,
      required this.periodeMulai,
      required this.pll,
      required this.premiAdd,
      required this.premiCasco,
      required this.premiTotal,
      required this.remarks,
      required this.rMATAUANGNAMA,
      required this.simulmv1Id,
      required this.theinsured,
      required this.thnBuat,
      required this.tpl,
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
          child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text("Simulasi # $simulmv1Id",
                  style: MyText.bodyLarge(context)!
                    .copyWith(color: MyColors.grey_40)),
                Container(height: 10),
                Text("Nama Tertanggung",
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_40)),
                Container(height: 5),
                Text(theinsured,
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_80)),
                Container(height: 10),                
                Text("Harga Kendaraan",
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_40)),
                Container(height: 5),
                Text(NumberFormat("#,###").format(harga),
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_80)),
                Container(height: 10),
                Text("Jenis Kendaraan",
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_40)),
                Container(height: 5),
                Text(grupNama,
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_80)),
                Container(height: 10),
                Text("Wilayah",
                style: MyText.bodyLarge(context)!
                    .copyWith(color: MyColors.grey_40)),
                Container(height: 5),
                Text(wilayahNama,
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_80)),
                Container(height: 10),
                Text("Jenis Cover",
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_40)),
                Container(height: 5),
                Text(coverName,
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_80)),
                Container(height: 10),
                Text("Lama Cover",
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_40)),
                Container(height: 5),
                Text("${NumberFormat("#,###").format(coverBulan)} bulan",
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_80)),
                Container(height: 10),                
            
                Text("Premi Total",
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_40)),
                Container(height: 5),
                Text(NumberFormat("#,###").format(premiTotal),
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_80)),
                Container(height: 10),
                
            
          ]),
        ));
  }
}
