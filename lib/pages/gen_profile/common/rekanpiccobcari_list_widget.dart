import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_profile/rekanpiccobcari_bloc.dart';
import 'package:joss_app/models/gen_profile/rekanpiccobcari_model.dart';
import '../../../common/constants.dart';

class RekanPicCobCariListWidget extends StatefulWidget {
  final String rekanPicId;
  final String viewMode; // 'tambah' | 'ubah' | 'display'
  final String searchText;

  const RekanPicCobCariListWidget({
    super.key,
    required this.rekanPicId,
    required this.viewMode,
    required this.searchText,
  });

  @override
  State<RekanPicCobCariListWidget> createState() =>
      _RekanPicCobCariListWidgetState();
}

class _RekanPicCobCariListWidgetState
    extends State<RekanPicCobCariListWidget> {
  late RekanPicCobCariBloc rekanPicCobCariBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    rekanPicCobCariBloc = BlocProvider.of<RekanPicCobCariBloc>(context);

    return BlocConsumer<RekanPicCobCariBloc, RekanPicCobCariState>(
      listener: (context, state) {
        if (state.isSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data berhasil disimpan!")),
          );
        }
      },
      builder: (context, state) {
        if (state.status == ListStatus.success) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada data COB.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemCount: state.items.length,
            itemBuilder: (_, index) {
              final item = state.items[index];

              // 🧩 Fungsi toggle reusable
              void toggleCheck() {
                if (widget.viewMode != 'display') {
                  rekanPicCobCariBloc.add(
                    UpdateCheckboxRekanPicCobEvent(
                      rekanPicCobItem: item,
                      isChecked: !item.isChecked,
                    ),
                  );
                }
              }

              return InkWell(
                onTap: toggleCheck, // ✅ klik di area teks juga aktifkan checkbox
                child: Container(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Checkbox(
                      activeColor: primaryColor,
                      value: item.isChecked,
                      onChanged: widget.viewMode == 'display'
                          ? null
                          : (val) => toggleCheck(),
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
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      rekanPicCobCariBloc.add(FetchRekanPicCobCariEvent());
    }
  }
}
