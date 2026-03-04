import 'package:flutter/material.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';


class RekanPicCobCariTileWidget extends StatelessWidget {
  final String cobNama;
  final String mrekanpiccobId;

  const RekanPicCobCariTileWidget(
      {super.key,
        required this.cobNama,
        required this.mrekanpiccobId});

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
                Text("cobNama",
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_40)),
                Container(height: 5),
                Text(
                    cobNama,
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_80)),
                Container(height: 10),
                Text("mrekanpiccobId",
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_40)),
                Container(height: 5),
                Text(
                    mrekanpiccobId,
                    style: MyText.bodyLarge(context)!
                        .copyWith(color: MyColors.grey_80)),
                Container(height: 10),
              ]),
        )
    );
  }
}