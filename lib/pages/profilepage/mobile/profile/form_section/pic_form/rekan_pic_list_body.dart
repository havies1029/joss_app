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
          print("[🌀 BlocListener] isSaved == true → Refresh list triggered");
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
    return ListView.separated(
      controller: _scrollController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.items.length > 3 ? 3 : state.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        final item = state.items[index];
        return _buildModernCard(item);
      },
    );
  }

  Widget _buildModernCard(dynamic item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.picNama ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.isDefault == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.green.shade200, width: 0.5),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  Text(
                    item.jabatanDesc ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (item.picEmail?.isNotEmpty == true || item.picHp?.isNotEmpty == true) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (item.picEmail?.isNotEmpty == true) ...[
                          Icon(
                            Icons.email_outlined,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              item.picEmail ?? '',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        if (item.picEmail?.isNotEmpty == true && item.picHp?.isNotEmpty == true) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 2,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (item.picHp?.isNotEmpty == true) ...[
                          Icon(
                            Icons.phone_outlined,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              item.picHp ?? '',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Action buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(
                  icon: Icons.edit_outlined,
                  onPressed: () {
                    if (widget.onEdit != null) {
                      widget.onEdit!(item.mrekanpicId);
                    }
                  },
                ),
                const SizedBox(width: 4),
                _buildActionButton(
                  icon: Icons.delete_outline,
                  onPressed: () {
                    if (widget.onDelete != null) {
                      widget.onDelete!(item.mrekanpicId);
                    } else {
                      showDialogHapus(item.mrekanpicId);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 0.5,
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.person_search_outlined,
                color: Colors.grey.shade400,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data PIC',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Data akan ditampilkan di sini',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      mRekanPicListBloc.add(FetchMRekanPicListEvent());
    }
  }

  void onHapusFunction(String recordId) {
    print("[🧨 DEBUG] Deleting ID: $recordId");
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