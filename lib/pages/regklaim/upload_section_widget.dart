import 'package:dio/dio.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:joss_app/models/regklaim/attachment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:joss_app/blocs/regklaim/attach_bloc.dart';
import 'package:joss_app/repositories/regklaim/picker_repository.dart';
import 'package:joss_app/repositories/regklaim/upload_repository.dart';
import 'attachment_picker_panel.dart';
import 'preview_pages.dart';

class UploadSectionWidget extends StatelessWidget {
  final String regklaim1Id;
  final String viewMode;

  const UploadSectionWidget({
    super.key,
    required this.regklaim1Id,
    required this.viewMode,
  });

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
      create: (_) => AttachBloc(
        pickerRepo: PickerRepositoryImpl(),
        uploadRepo: UploadRepositoryImpl(dio),
      ),
      child: BlocBuilder<AttachBloc, AttachState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              const Text(
                'Dokumen Pendukung',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              AttachmentPickerPanel(
                viewMode: viewMode,
                items: state.items,
                onPickFile: () => context
                    .read<AttachBloc>()
                    .add(PickFilesFromStorage()),
                onPickPhoto: () => context
                    .read<AttachBloc>()
                    .add(PickImageFromCamera()),
                onRemove: (id) => context
                    .read<AttachBloc>()
                    .add(RemoveAttachment(id)),
                onTapItem: (item) => openPreview(context, item),
              ),

              const SizedBox(height: 12),

              // OPTIONAL: upload per item (kalau mau eksplisit)
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

                        const SizedBox(width: 8),

                        _UploadActionButton(
                          item: item,
                          regklaim1Id: regklaim1Id,
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
    );
  }
}

class _UploadActionButton extends StatelessWidget {
  final AttachmentItem item;
  final String regklaim1Id;

  const _UploadActionButton({
    required this.item,
    required this.regklaim1Id,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AttachBloc>();

    switch (item.status) {
      case UploadStatus.queued:
        return ElevatedButton(
          onPressed: () => bloc.add(
            UploadOne(localId: item.localId, regklaim1Id: regklaim1Id),
          ),
          child: const Text('Upload'),
        );

      case UploadStatus.uploading:
        return OutlinedButton(
          onPressed: () => bloc.add(
            CancelUpload(item.localId),
          ),
          child: const Text('Cancel'),
        );

      case UploadStatus.failed:
      case UploadStatus.canceled:
        return ElevatedButton(
          onPressed: () => bloc.add(
            RetryUpload(localId: item.localId, regklaim1Id: regklaim1Id),
          ),
          child: const Text('Retry'),
        );

      case UploadStatus.success:
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
        );
    }
  }
}
