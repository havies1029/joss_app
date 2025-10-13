import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:joss_app/blocs/gen_profile/mrekanpiclist_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';

import '../../../../../common/constants.dart';
import '../../../../../models/combobox/combomjabatan_model.dart';
import '../../../../base/base_background_sidepage.dart';
import 'crud_pic/edit_pic.dart';
import 'crud_pic/tambah_pic.dart';

class MRekanPicListSimple extends StatefulWidget {
  const MRekanPicListSimple({super.key});

  @override
  State<MRekanPicListSimple> createState() => _MRekanPicListSimpleState();
}

class _MRekanPicListSimpleState extends State<MRekanPicListSimple> {
  late MRekanPicListBloc listBloc;
  late MRekanPicCrudBloc crudBloc;

  @override
  void initState() {
    super.initState();
    // fetch awal setelah context ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listBloc = context.read<MRekanPicListBloc>();
      crudBloc = context.read<MRekanPicCrudBloc>();
      listBloc.add(FetchMRekanPicListEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    listBloc = context.read<MRekanPicListBloc>();
    crudBloc = context.read<MRekanPicCrudBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent, // biarkan transparan; warna di container utama
      body: SafeArea(
        child: BaseBackgroundSidePage(
          title: 'Informasi PIC',
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Container(
                    width: double.infinity,
                    color: secondaryBlackColor, // <-- warna penuh layar
                    padding: EdgeInsets.symmetric(
                      horizontal: hPadding * 1.5, // ➜ jarak kiri/kanan ke tembok
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ===== Header: Total + Tambah PIC
                        BlocBuilder<MRekanPicListBloc, MRekanPicListState>(
                          builder: (context, state) {
                            final total = state.items.length;
                            return Row(
                              children: [
                                Text(
                                  'Total PIC: $total',
                                  style: bodyTextStyle(context, fontSize: 18),
                                ),
                                const Spacer(),
                                _PrimaryButton(
                                  onPressed: () async {
                                    final changed = await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<MRekanPicCrudBloc>(),
                                          child: const TambahPicWidget(),
                                        ),
                                      ),
                                    );
                                    if (changed == true) {
                                      listBloc.add(FetchMRekanPicListEvent());
                                    }
                                  },
                                  icon: const Icon(Icons.add, size: 20),
                                  label: 'Tambah PIC',
                                ),

                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        // ===== List read-only
                        BlocConsumer<MRekanPicCrudBloc, MRekanPicCrudState>(
                          listener: (context, state) {
                            if (state.isSaved) {
                              listBloc.add(FetchMRekanPicListEvent());
                            }
                          },
                          builder: (context, _) {
                            return BlocBuilder<MRekanPicListBloc, MRekanPicListState>(
                              builder: (context, state) {
                                if (state.status == ListStatus.initial) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 40),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                if (state.status == ListStatus.failure) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 12),
                                      Text(
                                        'Gagal memuat data PIC',
                                        style: bodyTextStyle(context),
                                      ),
                                      const SizedBox(height: 8),
                                      TextButton(
                                        onPressed: () =>
                                            listBloc.add(FetchMRekanPicListEvent()),
                                        child: const Text('Coba lagi'),
                                      ),
                                    ],
                                  );
                                }
                                if (state.items.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      'Belum ada PIC.',
                                      style: bodyTextStyle(context, fontSize: 16)
                                          .copyWith(color: hintGrey),
                                    ),
                                  );
                                }

                                return Column(
                                  children: List.generate(state.items.length, (i) {
                                    final it = state.items[i];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: i == state.items.length - 1 ? 0 : 14,
                                      ),
                                      child: _PicReadOnlyCard(
                                        title: 'PIC ${i + 1}',
                                        nama: it.picNama ?? '-',
                                        email: it.picEmail ?? '-',
                                        telp: it.picHp ?? '-',
                                        jabatan: it.jabatanDesc ?? '-',
                                        onEdit: () async {
                                          final jabatanModelFromList = ComboMJabatanModel(
                                            mjabatanId: it.mjabatanId!.toString(),
                                            jabatanDesc: it.jabatanDesc ?? '',
                                          );

                                          final changed = await Navigator.push<bool>(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => BlocProvider.value(
                                                value: context.read<MRekanPicCrudBloc>(),
                                                child: EditPicWidget(
                                                  mrekanpicId: it.mrekanpicId,
                                                  initNama: it.picNama,
                                                  initEmail: it.picEmail,
                                                  initHp: it.picHp,
                                                  initJabatanModel: jabatanModelFromList,
                                                  initIsDefault: it.isDefault ?? false,
                                                ),
                                              ),
                                            ),
                                          );
                                          if (changed == true) {
                                            listBloc.add(FetchMRekanPicListEvent());
                                          }
                                        },
                                        onDelete: () {
                                          _confirmDelete(context, it.mrekanpicId);
                                        },
                                      ),
                                    );
                                  }),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

  }

  void _confirmDelete(BuildContext context, String recordId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ShowDialogHapusWidget(
        onHapusFunction: (id) =>
            crudBloc.add(MRekanPicCrudHapusEvent(recordId: id)),
        recordId: recordId,
      ),
    ).then((_) {
      listBloc.add(CloseDialogMRekanPicListEvent());
    });
  }
}

/// ===== Card read-only: label sGrey, nilai primaryLightColor, radius cardBorderRadius
class _PicReadOnlyCard extends StatelessWidget {
  final String title;
  final String nama;
  final String email;
  final String telp;
  final String jabatan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PicReadOnlyCard({
    required this.title,
    required this.nama,
    required this.email,
    required this.telp,
    required this.jabatan,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle =
    bodyTextStyle(context, fontSize: 16).copyWith(color: cardGrey);
    final valueStyle =
    bodyTextStyle(context, fontSize: 16).copyWith(color: primaryLightColor);

    return Card(
      color: formGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        side: const BorderSide(color: sGrey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // tombol kiri atas
            Row(
              children: [
                _GhostIconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: onEdit,
                  bg: const Color(0xFFFFC107), // kuning soft
                ),
                const SizedBox(width: 8),
                _GhostIconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: onDelete,
                  bg: const Color(0xFFE53935), // merah soft
                ),
              ],
            ),
            const SizedBox(height: 10),

            Divider(color: sGrey, height: 20),

            const SizedBox(height: 6),

            _kv('Nama PIC :', nama, labelStyle, valueStyle),
            const SizedBox(height: 6),
            _kv('Email :', email, labelStyle, valueStyle),
            const SizedBox(height: 6),
            _kv('No. Telp :', telp, labelStyle, valueStyle),
            const SizedBox(height: 6),
            _kv('Jabatan :', jabatan, labelStyle, valueStyle),
          ],
        ),
      ),
    );
  }

  Widget _kv(
      String label,
      String value,
      TextStyle labelStyle,
      TextStyle valueStyle,
      ) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: '$label ', style: labelStyle),
          TextSpan(text: value, style: valueStyle),
        ],
      ),
    );
  }
}

/// ===== Button styles (ringan, tanpa AppButton)
class _PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final String label;
  const _PrimaryButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(label),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
      ),
    );
  }
}

class _GhostIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Color bg;
  const _GhostIconButton({
    required this.onPressed,
    required this.icon,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: icon,
        ),
      ),
    );
  }
}
