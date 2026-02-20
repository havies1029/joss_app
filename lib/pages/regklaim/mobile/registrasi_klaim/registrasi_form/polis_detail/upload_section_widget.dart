
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/registrasi_form/polis_detail/preview_pages.dart';
import '../../../../../../blocs/regklaim/attach_bloc.dart';
import '../../../../../../blocs/regklaim/regklaim1crud_bloc.dart';
import '../../../../../../common/app_data.dart';
import '../../../../../../common/constants.dart';
import '../../../../../../models/regklaim/attachment_item.dart';
import '../../../../../../repositories/regklaim/picker_repository.dart';
import '../../../../../../repositories/regklaim/upload_repository.dart';

import 'attachment_picker_panel.dart';

class UploadSectionWidget extends StatefulWidget {
  const UploadSectionWidget({super.key});

  @override
  State<UploadSectionWidget> createState() => _UploadSectionWidgetState();
}

class _UploadSectionWidgetState extends State<UploadSectionWidget> {
  String regklaim1Id = "";
  Regklaim1CrudBloc?regklaim1formBloc;

  @override
  void initState() {
    super.initState();
    regklaim1formBloc = context.read<Regklaim1CrudBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppData.apiDomain,
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer ${AppData.userToken}'
        },
      ),
    );

    return BlocProvider(
      create: (_) =>
          AttachBloc(
            pickerRepo: PickerRepositoryImpl(),
            uploadRepo: UploadRepositoryImpl(dio),
          ),

      child: MultiBlocListener(
        listeners: [

          // ==============================
          // LISTENER REGKLAIM1 (TRIGGER UPLOAD)
          // ==============================
          BlocListener<Regklaim1CrudBloc, Regklaim1CrudState>(
            listener: (context, state) {
              debugPrint("=== Regklaim1 Listener Triggered ===");

              if (!state.isSaved) {
                debugPrint("Skip: isSaved false");
                return;
              }

              if (state.hasFailure) {
                debugPrint("Skip: hasFailure true");
                return;
              }

              final regklaim1Id = state.regklaim1Id;

              final attachBloc = context.read<AttachBloc>();

              final items = attachBloc.state.items;

              for (final item in items) {
                if (item.status == UploadStatus.queued) {
                  attachBloc.add(
                    UploadOne(
                      localId: item.localId,
                      regklaim1Id: regklaim1Id,
                    ),
                  );
                }
              }
            },
          ),
        ],

        child: BlocBuilder<AttachBloc, AttachState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AttachmentPickerPanel(
                  items: state.items,
                  onPickFile: () =>
                      context.read<AttachBloc>().add(PickFilesFromStorage()),
                  onPickPhoto: () =>
                      context.read<AttachBloc>().add(PickImageFromCamera()),
                  onRemove: (id) =>
                      context.read<AttachBloc>().add(RemoveAttachment(id)),
                  onTapItem: (item) => openPreview(context, item),
                ),

                const SizedBox(height: hPadding),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final item = state.items[i];

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),

                          if (item.status == UploadStatus.uploading)
                            SizedBox(
                              width: 80,
                              child: LinearProgressIndicator(
                                value: item.progress,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UploadActionWidget extends StatefulWidget {
  final AttachmentItem item;
  final String regklaim1Id;

  const _UploadActionWidget({
    required this.item,
    required this.regklaim1Id,
  });

  @override
  State<_UploadActionWidget> createState() => _UploadActionWidgetState();
}

class _UploadActionWidgetState extends State<_UploadActionWidget> {
  bool _triggered = false;

  @override
  void didUpdateWidget(covariant _UploadActionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.item.status == UploadStatus.queued && !_triggered) {
      _triggered = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AttachBloc>().add(
          UploadOne(
            localId: widget.item.localId,
            regklaim1Id: widget.regklaim1Id,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AttachBloc>();

    switch (widget.item.status) {
      case UploadStatus.queued:
        return const SizedBox();

      case UploadStatus.uploading:
        return OutlinedButton(
          onPressed: () => bloc.add(
            CancelUpload(widget.item.localId),
          ),
          child: const Text('Cancel'),
        );

      case UploadStatus.failed:
      case UploadStatus.canceled:
        return ElevatedButton(
          onPressed: () => bloc.add(
            RetryUpload(
              localId: widget.item.localId,
              regklaim1Id: widget.regklaim1Id,
            ),
          ),
          child: const Text('Retry'),
        );

      case UploadStatus.success:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload ${widget.item.name} berhasil'),
              duration: const Duration(seconds: 2),
            ),
          );
          debugPrint("Berhasil Upload");
        });

        return const SizedBox();
    }
  }
}
