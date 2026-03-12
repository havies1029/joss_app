import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/blocs/gen_profile/rekanpiccobcari_bloc.dart';
import 'package:joss_app/pages/gen_profile/common/rekanpiccobcari_list_widget.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import '../../../common/constants.dart';
import '../../../models/gen_profile/rekanpiccobcari_model.dart';
import '../../base/base_background_sidepage.dart';

class RekanPicCobCariPage extends StatefulWidget {
  final String rekanPicId;
  final String viewMode; // 'tambah' | 'ubah' | 'display'
  final List<RekanPicCobCariModel> initialSelectedItems;

  const RekanPicCobCariPage({
    super.key,
    required this.rekanPicId,
    required this.viewMode,
    this.initialSelectedItems = const [],
  });

  @override
  State<RekanPicCobCariPage> createState() => _RekanPicCobCariPageState();
}

class _RekanPicCobCariPageState extends State<RekanPicCobCariPage> {
  late RekanPicCobCariBloc rekanPicCobCariBloc;
  final TextEditingController _searchController = TextEditingController();

  String get _effectivePicId =>
      widget.viewMode == 'tambah' ? '0' : widget.rekanPicId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      rekanPicCobCariBloc = context.read<RekanPicCobCariBloc>();

      rekanPicCobCariBloc.add(
        RefreshRekanPicCobCariEvent(
          rekanPicId: _effectivePicId,
          searchText: '',
        ),
      );

      if (widget.initialSelectedItems.isNotEmpty) {
        rekanPicCobCariBloc.add(
          InitialSelectedCOBRekanPicCobEvent(
            selectedCOB: List<RekanPicCobCariModel>.from(
              widget.initialSelectedItems.map(
                    (e) => e.copyWith(isChecked: true),
              ),
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshList() {
    rekanPicCobCariBloc.add(
      RefreshRekanPicCobCariEvent(
        rekanPicId: _effectivePicId,
        searchText: _searchController.text.trim(),
      ),
    );

    if (widget.initialSelectedItems.isNotEmpty) {
      rekanPicCobCariBloc.add(
        InitialSelectedCOBRekanPicCobEvent(
          selectedCOB: List<RekanPicCobCariModel>.from(
            widget.initialSelectedItems.map(
                  (e) => e.copyWith(isChecked: true),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    rekanPicCobCariBloc = context.read<RekanPicCobCariBloc>();

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
                  SizedBox(height: vPadding),
                  Row(
                    children: [
                      Expanded(
                        child: ListPageFilterBarUIWidget(
                          searchController: _searchController,
                          searchButton: IconButton(
                            icon: const Icon(Icons.search, color: Colors.white70),
                            onPressed: _refreshList,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _refreshList,
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C8FF),
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
                  Expanded(
                    child: RekanPicCobCariListWidget(
                      rekanPicId: _effectivePicId,
                      viewMode: widget.viewMode,
                      searchText: _searchController.text,
                    ),
                  ),
                  if (widget.viewMode != 'display')
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: BlocBuilder<RekanPicCobCariBloc, RekanPicCobCariState>(
                          builder: (context, state) {
                            final selectedItems =
                            state.items.where((e) => e.isChecked).toList();

                            final hasSelected = selectedItems.isNotEmpty;

                            return GestureDetector(
                              onTap: hasSelected
                                  ? () {
                                Navigator.pop(context, selectedItems);
                              }
                                  : null,
                              child: Opacity(
                                opacity: hasSelected ? 1.0 : 0.5,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
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
                  SizedBox(height: vPadding),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}