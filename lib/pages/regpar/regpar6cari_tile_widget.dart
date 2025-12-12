import 'package:joss_app/blocs/regpar/regpar6form_bloc.dart';
import 'package:joss_app/blocs/regpar/regpar_download_foto_object_bloc.dart';
import 'package:joss_app/blocs/regpar/regpar_download_foto_object_event.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Regpar6CariTileWidget extends StatefulWidget {
  final String regpar1Id;
  final String fotoCaption;
  final String regpar6Id;

  const Regpar6CariTileWidget({
    super.key,
    required this.regpar1Id,
    required this.fotoCaption,
    required this.regpar6Id,
  });

  @override
  State<Regpar6CariTileWidget> createState() => _Regpar6CariTileWidgetState();
}

class _Regpar6CariTileWidgetState extends State<Regpar6CariTileWidget> {
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
              "fotoCaption",
              style: MyText.bodyLarge(context)!.copyWith(
                color: MyColors.grey_40,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.fotoCaption,
              style: MyText.bodyLarge(context)!.copyWith(
                color: MyColors.grey_80,
              ),
            ),
            const SizedBox(height: 10),

            /// FOTO NETWORK
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl:
                    "${AppData.apiDomain}api/regpar/regpar6cari/fotoobject/getfoto/${widget.regpar6Id}",
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
                        context.read<Regpar6FormBloc>().add(
                						Regpar6FormHapusEvent(recordId: widget.regpar6Id));
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
                        context.read<RegparDownloadFotoObjectBloc>().add(
                          DownloadFileEvent(regpar6Id: widget.regpar6Id));
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
