import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../blocs/gen_profile/rekanpiccobcari_bloc.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../models/gen_profile/rekanpiccobcari_model.dart';
import '../../../../../../widgets/listpage_filter_bar_ui.dart';
import '../../../../../base/base_background_sidepage.dart';

class ListPicWidget extends StatefulWidget {
  final String mrekanpicId;

  const ListPicWidget({
    super.key,
    required this.mrekanpicId,
  });

  @override
  State<ListPicWidget> createState() => _ListPicWidgetState();
}

class _ListPicWidgetState extends State<ListPicWidget> {
  late RekanPicCobCariBloc rekanPicCobCariBloc;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    rekanPicCobCariBloc = context.read<RekanPicCobCariBloc>();

    _scrollController.addListener(_onScroll);

    rekanPicCobCariBloc.add(
      RefreshRekanPicCobCariEvent(
        rekanPicId: widget.mrekanpicId,
        searchText: '',
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final state = rekanPicCobCariBloc.state;
    if (state.hasReachedMax || state.isFetchingMore) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent) {
      rekanPicCobCariBloc.add(FetchRekanPicCobCariEvent());
    }
  }

  Future<void> _refreshList() async {
    rekanPicCobCariBloc.add(
      RefreshRekanPicCobCariEvent(
        rekanPicId: widget.mrekanpicId,
        searchText: _searchController.text.trim(),
      ),
    );
  }

  void _toggleCheck(RekanPicCobCariModel item) {
    rekanPicCobCariBloc.add(
      UpdateCheckboxRekanPicCobEvent(
        rekanPicCobItem: item,
        isChecked: !item.isChecked,
      ),
    );
  }

  Widget _buildCobList() {
    return BlocConsumer<RekanPicCobCariBloc, RekanPicCobCariState>(
      listener: (context, state) {
        if (state.isSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil disimpan!'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == ListStatus.failure) {
          return RefreshIndicator(
            onRefresh: _refreshList,
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(
                  height: 400,
                  child: Center(
                    child: Text(
                      'Gagal memuat data COB.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state.status == ListStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.status == ListStatus.success && state.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refreshList,
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(
                  height: 400,
                  child: Center(
                    child: Text(
                      'Tidak ada data COB.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshList,
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: state.items.length + (state.isFetchingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final item = state.items[index];

              return InkWell(
                onTap: () => _toggleCheck(item),
                child: Container(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Checkbox(
                      activeColor: primaryColor,
                      value: item.isChecked,
                      onChanged: (_) => _toggleCheck(item),
                    ),
                    title: Text(
                      item.cobNama,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'COB ID: ${item.mcobId}',
                      style: const TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<RekanPicCobCariBloc, RekanPicCobCariState>(
      builder: (context, state) {
        final hasSelected = state.selectedItems.isNotEmpty;

        return GestureDetector(
          onTap: hasSelected
              ? () {
            Navigator.pop(context, state.selectedItems);
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
                    'Simpan Pilihan',
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
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
                            borderRadius:
                            BorderRadius.circular(cardBorderRadius),
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
                                'Refresh',
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
                  const SizedBox(height: hPadding),
                  Expanded(
                    child: _buildCobList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _buildSaveButton(),
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