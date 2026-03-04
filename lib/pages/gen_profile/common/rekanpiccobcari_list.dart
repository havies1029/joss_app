import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/blocs/gen_profile/rekanpiccobcari_bloc.dart';
import 'package:joss_app/pages/gen_profile/common/rekanpiccobcari_list_widget.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import '../../../common/constants.dart';
import '../../base/base_background_sidepage.dart';

class RekanPicCobCariPage extends StatefulWidget {
  final String rekanPicId;
  final String viewMode; // 'tambah' | 'ubah' | 'display'

  const RekanPicCobCariPage({
    super.key,
    required this.rekanPicId,
    required this.viewMode,
  });

  @override
  State<RekanPicCobCariPage> createState() => _RekanPicCobCariPageState();
}

class _RekanPicCobCariPageState extends State<RekanPicCobCariPage> {
  late RekanPicCobCariBloc rekanPicCobCariBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      rekanPicCobCariBloc = BlocProvider.of<RekanPicCobCariBloc>(context);

      final picId = widget.viewMode == 'tambah' ? '0' : widget.rekanPicId;

      // 🔹 Bedakan: ubah juga refresh paksa biar sinkron
      rekanPicCobCariBloc.add(
        RefreshRekanPicCobCariEvent(
          rekanPicId: picId,
          searchText: '',
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    rekanPicCobCariBloc = BlocProvider.of<RekanPicCobCariBloc>(context);

    return Scaffold(
      body: SafeArea(
        child: BaseBackgroundSidePage(
          title: 'Daftar COB',
          child: Container(
            color: secondaryBlackColor,
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5),
              child: Column(
                children: [
                  SizedBox(height: vPadding,),
                  // 🔍 Search bar + refresh button
                  Row(
                    children: [
                      // 🔍 Search field
                      Expanded(
                        child: ListPageFilterBarUIWidget(
                          searchController: _searchController,
                          searchButton: IconButton(
                            icon: const Icon(Icons.search, color: Colors.white70),
                            onPressed: () {
                              rekanPicCobCariBloc.add(
                                RefreshRekanPicCobCariEvent(
                                  rekanPicId: '0',
                                  searchText: _searchController.text,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // 🔄 Refresh button (tinggi sama persis dengan filter bar)
                      GestureDetector(
                        onTap: () {
                          rekanPicCobCariBloc.add(
                            RefreshRekanPicCobCariEvent(
                              rekanPicId: '0',
                              searchText: _searchController.text,
                            ),
                          );
                        },
                        child: Container(
                          height: 44, // ✅ sama seperti filter bar
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C8FF), // 💠 Biru refresh
                            borderRadius: BorderRadius.circular(cardBorderRadius),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/refresh_cob_icon.svg',
                                width: 18,
                                height: 18,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "Refresh",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 10),

                  // 📋 List COB
                  Expanded(
                    child: RekanPicCobCariListWidget(
                      rekanPicId: widget.rekanPicId,
                      viewMode: widget.viewMode,
                      searchText: _searchController.text,
                    ),
                  ),

                  // 💾 Button Simpan Pilihan
                  // 💾 Button Simpan Pilihan
                  if (widget.viewMode != 'display')
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: BlocBuilder<RekanPicCobCariBloc, RekanPicCobCariState>(
                          builder: (context, state) {
                            final hasSelected = state.items.any((e) => e.isChecked);

                            return GestureDetector(
                              onTap: hasSelected
                                  ? () async {
                                if (widget.viewMode == 'ubah') {
                                  // ✅ mode edit → langsung update ke API
                                  // final items = rekanPicCobCariBloc.state.items;
                                  // final listCheckbox = List<RekanPicCobCariCheckboxModel>.generate(
                                  //   items.length,
                                  //       (index) => RekanPicCobCariCheckboxModel(
                                  //     mcobId: items[index].mcobId,
                                  //     isChecked: items[index].isChecked,
                                  //   ),
                                  // );
                                  // listCheckbox.removeWhere((e) => !e.isChecked);
                                  //
                                  // final repo = RekanPicCobCariRepository();
                                  // final result = await repo.rekanPicCobUpdateList(
                                  //   widget.rekanPicId,
                                  //   listCheckbox,
                                  // );
                                  //
                                  // if (result.success) {
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     const SnackBar(content: Text("✅ Data COB berhasil disimpan")),
                                  //   );
                                  //   Navigator.pop(context, items);
                                  // } else {
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     const SnackBar(content: Text("⚠️ Gagal menyimpan data COB")),
                                  //   );
                                  // }
                                  Navigator.pop(context, state.selectedItems);
                                } else if (widget.viewMode == 'tambah') {
                                  // ✅ mode tambah → pending simpan, belum ke API
                                  Navigator.pop(context, state.selectedItems);
                                }
                              }
                                  : null, // disable kalau gak ada centang
                              child: Opacity(
                                opacity: hasSelected ? 1.0 : 0.5,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4ACF1E),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/save_btn_pic.svg',
                                        width: 18,
                                        height: 18,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        "Simpan Pilihan",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),


                  SizedBox(height: vPadding,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
