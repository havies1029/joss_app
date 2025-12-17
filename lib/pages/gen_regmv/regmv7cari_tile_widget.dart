import 'package:joss_app/blocs/gen_regmv/regmv7form_bloc.dart';
import 'package:joss_app/blocs/gen_regmv/regmv_download_foto_acc_bloc.dart';
import 'package:joss_app/blocs/gen_regmv/regmv_download_foto_acc_event.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Regmv7CariTileWidget extends StatefulWidget {
  final String accNama;
  final String regmv7Id;

  const Regmv7CariTileWidget({
    super.key,
    required this.accNama,
    required this.regmv7Id,
  });

  @override
  State<Regmv7CariTileWidget> createState() => _Regmv7CariTileWidgetState();
}

class _Regmv7CariTileWidgetState extends State<Regmv7CariTileWidget> {
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
              "accNama",
              style: MyText.bodyLarge(context)!.copyWith(color: MyColors.grey_40),
            ),
            const SizedBox(height: 5),
            Text(
              widget.accNama, // ⬅️ gunakan widget.
              style: MyText.bodyLarge(context)!.copyWith(color: MyColors.grey_80),
            ),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl:
                    "${AppData.apiDomain}api/regmv/regmv7cari/fotoacc/getfoto/${widget.regmv7Id}",
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
                        context.read<Regmv7FormBloc>().add(
                						Regmv7FormHapusEvent(recordId: widget.regmv7Id));
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
                        context.read<RegmvDownloadFotoAccBloc>().add(
                          DownloadFileEvent(regmv7Id: widget.regmv7Id));
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
