import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/gen_regmv/mobile/preview/regmv5_preview_page.dart';
import 'package:joss_app/pages/gen_regmv/mobile/preview/regmv5_storage_picker_panel.dart';

import '../../../../blocs/gen_regmv/regmv_upload_foto_mobil_bloc.dart';

class Regmv5StoragePickerSectionWidget extends StatelessWidget {
  final bool showRequiredError;

  const Regmv5StoragePickerSectionWidget({
    super.key,
    this.showRequiredError = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RegmvUploadFotoMobilBloc, Regmv5UploadFotoObjectState>(
          listenWhen: (prev, curr) =>
          prev.toast != curr.toast && curr.toast != null,
          listener: (context, state) {
            final msg = state.toast;
            if (msg == null || msg.isEmpty) return;

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(msg)),
              );
          },
        ),
      ],
      child: BlocBuilder<RegmvUploadFotoMobilBloc, Regmv5UploadFotoObjectState>(
        builder: (context, state) {
          final bloc = context.read<RegmvUploadFotoMobilBloc>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Regmv5StoragePickerPanel(
                items: state.items,
                isLoading: state.isClearing && state.items.isEmpty,
                onPickFile: () => bloc.add(Regmv5StoragePickFilesFromStorage()),
                onPickPhoto: () => bloc.add(Regmv5StoragePickImageFromCamera()),
                onRemove: (id) => bloc.add(Regmv5StorageRemoveAttachment(id)),
                onTapItem: (item) => openPreviewRegmv5(context, item),

                showRequiredError: showRequiredError,
                requiredErrorText: "Lampiran wajib diisi",
              ),
            ],
          );
        },
      ),
    );
  }
}