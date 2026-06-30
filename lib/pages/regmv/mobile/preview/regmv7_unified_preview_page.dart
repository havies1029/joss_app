import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/regmv/mobile/preview/regmv7_preview_page.dart';
import 'package:joss_app/pages/regmv/mobile/preview/regmv7_storage_picker_panel.dart';

import '../../../../blocs/gen_regmv/regmv_upload_foto_acc_bloc.dart';
import '../../../../common/constants.dart';

class Regmv7StoragePickerSectionWidget extends StatelessWidget {
  final bool showRequiredError;

  const Regmv7StoragePickerSectionWidget({
    super.key,
    this.showRequiredError = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RegmvUploadFotoAccBloc, Regmv7UploadFotoObjectState>(
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
      child: BlocBuilder<RegmvUploadFotoAccBloc, Regmv7UploadFotoObjectState>(
        builder: (context, state) {
          final bloc = context.read<RegmvUploadFotoAccBloc>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Regmv7StoragePickerPanel(
                items: state.items,
                isLoading: state.isClearing && state.items.isEmpty,

                locked: state.isActionLocked,
                onLockedTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      errorSnackBar(
                        "Sedang menghitung premi, foto tidak bisa diubah dulu.",
                      ),
                    );
                },

                onPickFile: () => bloc.add(Regmv7StoragePickFilesFromStorage()),
                onPickPhoto: () => bloc.add(Regmv7StoragePickImageFromCamera()),
                onRemove: (id) => bloc.add(Regmv7StorageRemoveAttachment(id)),
                onTapItem: (item) => openPreviewRegmv7(context, item),

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
