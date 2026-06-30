
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/regklaim/mobile/registrasi_klaim/registrasi_form/polis_detail/preview_pages.dart';
import '../../../../../../blocs/regklaim/attach_bloc.dart';
import '../../../../../../blocs/regklaim/regklaim1crud_bloc.dart';
import '../../../../../../models/regklaim/attachment_item.dart';
import '../../../../../../common/constants.dart';
import 'attachment_picker_panel.dart';

class UploadSectionWidget extends StatefulWidget {
  const UploadSectionWidget({super.key});

  @override
  State<UploadSectionWidget> createState() => _UploadSectionWidgetState();
}

class _UploadSectionWidgetState extends State<UploadSectionWidget> {
  Regklaim1CrudBloc? regklaim1formBloc;

  @override
  void initState() {
    super.initState();
    regklaim1formBloc = context.read<Regklaim1CrudBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
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

            // AttachBloc dari parent
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

        BlocListener<AttachBloc, AttachState>(
          listenWhen: (prev, curr) =>
          prev.toast != curr.toast && curr.toast != null,
          listener: (context, state) {
            final msg = state.toast;
            if (msg == null || msg.isEmpty) return;

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                errorSnackBar(msg),
              );
          },
        ),
      ],
      child: BlocBuilder<AttachBloc, AttachState>(
        builder: (context, state) {
          final attachBloc = context.read<AttachBloc>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AttachmentPickerPanel(
                items: state.items,
                onPickFile: () => attachBloc.add(PickFilesFromStorage()),
                onPickPhoto: () => attachBloc.add(PickImageFromCamera()),
                onRemove: (id) => attachBloc.add(RemoveAttachment(id)),
                onTapItem: (item) => openPreview(context, item),
              ),
            ],
          );
        },
      ),
    );
  }
}
