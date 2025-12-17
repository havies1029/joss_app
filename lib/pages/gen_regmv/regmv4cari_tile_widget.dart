import 'package:joss_app/blocs/gen_regmv/regmv4form_bloc.dart';
import 'package:joss_app/blocs/gen_regmv/regmv_download_foto_stnk_bloc.dart';
import 'package:joss_app/blocs/gen_regmv/regmv_download_foto_stnk_event.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Regmv4CariTileWidget extends StatefulWidget {
  final String caption;
  final String regmv4Id;

  const Regmv4CariTileWidget({
    super.key,
    required this.caption,
    required this.regmv4Id,
  });

  @override
  State<Regmv4CariTileWidget> createState() => _Regmv4CariTileWidgetState();
}

class _Regmv4CariTileWidgetState extends State<Regmv4CariTileWidget> {
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
            Text(
              "caption",
              style: MyText.bodyLarge(context)!.copyWith(
                color: MyColors.grey_40,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.caption,
              style: MyText.bodyLarge(context)!.copyWith(
                color: MyColors.grey_80,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "regmv4Id",
              style: MyText.bodyLarge(context)!.copyWith(
                color: MyColors.grey_40,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.regmv4Id,
              style: MyText.bodyLarge(context)!.copyWith(
                color: MyColors.grey_80,
              ),
            ),
            const SizedBox(height: 10),

            // FOTO
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl:
                    "${AppData.apiDomain}api/regmv/regmv4cari/stnk/getfoto/${widget.regmv4Id}",
                httpHeaders: {
                  "Authorization": "Bearer ${AppData.userToken}",
                },
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image, color: Colors.red),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<Regmv4FormBloc>().add(
                										  Regmv4FormHapusEvent(recordId: widget.regmv4Id));
                      },
                      child: const Text(
                        'Hapus',
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
                        context.read<RegmvDownloadFotoStnkBloc>().add(
                                      DownloadFileEvent(regmv4Id: widget.regmv4Id));
                      },
                      child: const Text(
                        'Download',
                        style: TextStyle(fontSize: 13.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
