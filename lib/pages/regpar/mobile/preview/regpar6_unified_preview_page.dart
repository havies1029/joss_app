import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/regpar/mobile/preview/regpar6_preview_page.dart';
import 'package:joss_app/pages/regpar/mobile/preview/regpar6_storage_picker_panel.dart';

import '../../../../blocs/gen_regmv/regmv_upload_foto_acc_bloc.dart';
import '../../../../blocs/regpar/regpar_upload_foto_object_bloc.dart';


class Regpar6StoragePickerSectionWidget extends StatelessWidget {
  final bool showRequiredError;

  const Regpar6StoragePickerSectionWidget({
    super.key,
    this.showRequiredError = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RegparUploadFotoObjectBloc, RegParUploadFotoObjectState>(
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
      child: BlocBuilder<RegparUploadFotoObjectBloc, RegParUploadFotoObjectState>(
        builder: (context, state) {
          final bloc = context.read<RegparUploadFotoObjectBloc>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Regpar6StoragePickerPanel(
                items: state.items,
                isLoading: state.isClearing && state.items.isEmpty,
                onPickFile: () => bloc.add(RegparStoragePickFilesFromStorage()),
                onPickPhoto: () => bloc.add(RegparStoragePickImageFromCamera()),
                onRemove: (id) => bloc.add(RegparStorageRemoveAttachment(id)),
                onTapItem: (item) => openPreviewPar6(context, item),

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