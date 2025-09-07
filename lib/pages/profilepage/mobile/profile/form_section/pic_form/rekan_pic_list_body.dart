import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';
import 'package:joss_app/blocs/gen_profile/mrekanpiclist_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekanpiccrud_bloc.dart';

class MRekanPicListListWidget extends StatefulWidget {
  final void Function(String recordId)? onEdit;
  final void Function(String recordId)? onDelete;

  const MRekanPicListListWidget({super.key, this.onEdit, this.onDelete});

  @override
  State<MRekanPicListListWidget> createState() => _MRekanPicListListWidgetState();
}

class _MRekanPicListListWidgetState extends State<MRekanPicListListWidget> {
  late MRekanPicListBloc mRekanPicListBloc;
  late MRekanPicCrudBloc mRekanPicCrudBloc;
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
    mRekanPicListBloc = BlocProvider.of<MRekanPicListBloc>(context);
    mRekanPicCrudBloc = BlocProvider.of<MRekanPicCrudBloc>(context);

    return BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
      listener: (context, state) {
        if (state.isSaved) {
          mRekanPicListBloc.add(FetchMRekanPicListEvent());
        }
      },
      child: BlocConsumer<MRekanPicListBloc, MRekanPicListState>(
        buildWhen: (previous, current) => current.status == ListStatus.success,
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == ListStatus.success) {
            if (state.items.isEmpty) return _buildEmptyState();
            return _buildListView(state);
          } else {
            return _buildEmptyState();
          }
        },
      ),
    );
  }

  Widget _buildListView(MRekanPicListState state) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.items.length > 3 ? 3 : state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return _buildSimpleCard(item);
      },
    );
  }

  Widget _buildSimpleCard(dynamic item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.picNama ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(item.jabatanDesc ?? ''),
                  if (item.picEmail?.isNotEmpty == true)
                    Text(item.picEmail ?? ''),
                  if (item.picHp?.isNotEmpty == true)
                    Text(item.picHp ?? ''),
                  if (item.isDefault == true)
                    const Text('Default'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                if (widget.onEdit != null) {
                  widget.onEdit!(item.mrekanpicId);
                }
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                if (widget.onDelete != null) {
                  widget.onDelete!(item.mrekanpicId);
                } else {
                  showDialogHapus(item.mrekanpicId);
                }
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text('Belum ada data PIC'),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      mRekanPicListBloc.add(FetchMRekanPicListEvent());
    }
  }

  void onHapusFunction(String recordId) {
    mRekanPicCrudBloc.add(MRekanPicCrudHapusEvent(recordId: recordId));
  }

  void showDialogHapus(String recordId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return ShowDialogHapusWidget(
          onHapusFunction: onHapusFunction,
          recordId: recordId,
        );
      },
    ).then((_) {
      mRekanPicListBloc.add(CloseDialogMRekanPicListEvent());
    });
  }
}