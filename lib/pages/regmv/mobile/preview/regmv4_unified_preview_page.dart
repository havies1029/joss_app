import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/regmv/mobile/preview/regmv4_preview_page.dart';

import '../../../../blocs/gen_regmv/regmv_upload_stnk_bloc.dart';
import '../../../../common/constants.dart';
import 'regmv4_storage_picker_panel.dart';

class Regmv4StoragePickerSectionWidget extends StatelessWidget {
  final bool showRequiredError;

  const Regmv4StoragePickerSectionWidget({
    super.key,
    this.showRequiredError = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RegmvUploadStnkBloc, Regmv4UploadFotoObjectState>(
          listenWhen: (prev, curr) =>
          prev.toast != curr.toast && curr.toast != null,
          listener: (context, state) {
            final msg = state.toast;
            if (msg == null || msg.isEmpty) return;

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                errorSnackBar(msg ?? 'Terjadi kesalahan'),
              );
          },
        ),
      ],
      child: BlocBuilder<RegmvUploadStnkBloc, Regmv4UploadFotoObjectState>(
        builder: (context, state) {
          final bloc = context.read<RegmvUploadStnkBloc>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Regmv4StoragePickerPanel(
                items: state.items,
                isLoading: state.isClearing && state.items.isEmpty,

                onPickFile: () => bloc.add(Regmv4StoragePickFilesFromStorage()),
                onPickPhoto: () => bloc.add(Regmv4StoragePickImageFromCamera()),
                onRemove: (id) => bloc.add(Regmv4StorageRemoveAttachment(id)),
                onTapItem: (item) => openPreviewRegmv4(context, item),

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