import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekanpiclist_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekanpiccrud_bloc.dart';
import 'package:joss_app/blocs/gen_profile/rekanpiccobcari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/combobox/combomjabatan_model.dart';
import 'package:joss_app/pages/profile/mobile/profile/form_section/crud_pic/tambah_pic.dart';
import 'package:joss_app/pages/profile/mobile/profile/form_section/crud_pic/edit_pic.dart';
import 'package:joss_app/widgets/showdialoghapus_widget.dart';

import '../../../../../../blocs/gen_invite/invite_bloc.dart';
import '../../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../../../repositories/gen_invite/invite_repository.dart';
import '../../../../../../widgets/apptheme/invite_success_popup.dart';
import '../../../../../base/base_background_sidepage.dart';


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
      backgroundColor: Colors.transparent,
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
                    color: secondaryBlackColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: hPadding * 1.5,
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
                                Text('Total PIC: $total',
                                    style: bodyTextStyle(context, fontSize: 18)),
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

                        const SizedBox(height: hPadding),

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
                                      Text('Gagal memuat data PIC',
                                          style: bodyTextStyle(context)),
                                      const SizedBox(height: 8),
                                      TextButton(
                                        onPressed: () => listBloc.add(FetchMRekanPicListEvent()),
                                        child: const Text('Coba lagi'),
                                      ),
                                    ],
                                  );
                                }

                                if (state.items.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Text('Belum ada PIC.',
                                        style: bodyTextStyle(context, fontSize: 16)
                                            .copyWith(color: hintGrey)),
                                  );
                                }

                                return Column(
                                  children: List.generate(state.items.length, (i) {
                                    final it = state.items[i];
                                    if (it.mrekanpicId.isEmpty) {
                                      debugPrint(
                                          '⛔ Skip card karena mrekanpicId kosong untuk ${it.picNama}');
                                      return const SizedBox.shrink();
                                    }

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
                                        mrekanpicId: it.mrekanpicId,
                                        statusPic: it.statusPic,
                                        onEdit: () async {
                                          final jabatanModelFromList = ComboMJabatanModel(
                                            mjabatanId: it.mjabatanId.toString(),
                                            jabatanDesc: it.jabatanDesc ?? '',
                                          );

                                          final changed = await Navigator.push<bool>(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => MultiBlocProvider(
                                                providers: [
                                                  BlocProvider.value(value: context.read<MRekanPicCrudBloc>()),
                                                  BlocProvider(create: (_) => RekanPicCobCariBloc()), // ✅ Tambah ini
                                                ],
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
    // if (recordId.trim().isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('ID PIC kosong, tidak bisa dihapus.')),
    //   );
    //   return;
    // }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ShowDialogHapusWidget(
        onHapusFunction: (id) {
          crudBloc.add(MRekanPicCrudHapusEvent(recordId: id));
        },
        recordId: recordId,
      ),
    );

  }

}

// ====================================================================
// CARD READ ONLY dengan load COB terpisah
// ====================================================================

class _PicReadOnlyCard extends StatefulWidget {
  final String title;
  final String nama;
  final String email;
  final String telp;
  final String jabatan;
  final String mrekanpicId;
  final String? statusPic; // 🔹 Tambahkan ini
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PicReadOnlyCard({
    required this.title,
    required this.nama,
    required this.email,
    required this.telp,
    required this.jabatan,
    required this.mrekanpicId,
    required this.onEdit,
    required this.onDelete,
    this.statusPic, // 🔹 Tambahkan ini juga
  });


  @override
  State<_PicReadOnlyCard> createState() => _PicReadOnlyCardState();
}

class _PicReadOnlyCardState extends State<_PicReadOnlyCard> {
  late final RekanPicCobCariBloc cobBloc;

  @override
  void initState() {
    super.initState();
    cobBloc = RekanPicCobCariBloc();

    /// Delay fetch biar nunggu UI mount
    Future.microtask(() {
      if (widget.mrekanpicId.isNotEmpty) {
        debugPrint('🚀 Fetch COB untuk ${widget.mrekanpicId}');
        cobBloc.add(RefreshRekanPicCobCariEvent(
          rekanPicId: widget.mrekanpicId,
          searchText: '',
        ));
      } else {
        debugPrint('⛔ Skip fetch karena mrekanpicId kosong');
      }
    });
  }

  @override
  void dispose() {
    cobBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle =
    bodyTextStyle(context, fontSize: 16).copyWith(color: cardGrey);
    final valueStyle =
    bodyTextStyle(context, fontSize: 16).copyWith(color: primaryLightColor);

    return BlocProvider.value(
      value: cobBloc,
      child: Card(
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
              Row(
                children: [
                  _GhostIconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: widget.onEdit,
                    bg: const Color(0xFFFFC107),
                  ),
                  const SizedBox(width: 8),
                  _GhostIconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: widget.onDelete,
                    bg: const Color(0xFFE53935),
                  ),
                  const Spacer(),

                  /// 🔹 Tombol Kirim Undangan — scoped Bloc per card
                  // 🔹 Hanya tampil kalau statusPic bukan "sudah aksep"
                  if (widget.statusPic?.toLowerCase() != 'sudah aksep') ...[
                    BlocProvider(
                      create: (_) => InviteBloc(repo: InviteRepository()),
                      child: BlocConsumer<InviteBloc, InviteState>(
                        listener: (context, state) async {
                          if (state.isSuccess) {
                            await showDialog(
                              context: context,
                              builder: (_) => const InviteSuccessPopup(),
                            );
                          } else if (state.message.isNotEmpty && !state.isLoading) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state.isLoading;

                          return _GhostIconButtonWithLabel(
                            label: isLoading ? "Mengirim..." : "Kirim Undangan",
                            icon: isLoading
                                ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : const Icon(Icons.send, size: 18, color: Colors.white),
                            bg: const Color(0xFF2196F3),
                            onPressed: isLoading
                                ? null
                                : () {
                              final mrekan1Id =
                                  context.read<MRekan1CrudBloc>().state.record?.mrekan1Id;

                              if (mrekan1Id == null || mrekan1Id.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Data klien belum siap. Silakan coba lagi.'),
                                  ),
                                );
                                return;
                              }

                              final userId = mrekan1Id;
                              final email = widget.email.trim().toLowerCase();


                              context.read<InviteBloc>().add(
                                SendInviteEvent(userId: userId, email: email),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: hPadding),
              Divider(color: sGrey, height: 20),
              _kv('Nama PIC :', widget.nama, labelStyle, valueStyle),
              _kv('Email :', widget.email, labelStyle, valueStyle),
              _kv('No. Telp :', widget.telp, labelStyle, valueStyle),
              _kv('Jabatan :', widget.jabatan, labelStyle, valueStyle),
              Divider(color: sGrey, height: 20),
              const SizedBox(height: 8),
              Text('Polis yang bisa diakses:',
                  style: bodyTextStyle(context, fontSize: 16)
                      .copyWith(color: hintGrey, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _CobListSection(rekanPicId: widget.mrekanpicId)

            ],
          ),
        ),
      ),
    );
  }

  Widget _kv(String label, String value, TextStyle labelStyle, TextStyle valueStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(text: '$label ', style: labelStyle),
          TextSpan(text: value, style: valueStyle),
        ]),
      ),
    );
  }
}

// ====================================================================
// COB SECTION
// ====================================================================
class _CobListSection extends StatelessWidget {
  final String rekanPicId;
  const _CobListSection({required this.rekanPicId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RekanPicCobCariBloc()
        ..add(RefreshRekanPicCobCariEvent(
          rekanPicId: rekanPicId,
          searchText: '',
        )),
      child: BlocBuilder<RekanPicCobCariBloc, RekanPicCobCariState>(
        builder: (context, state) {
          if (state.status == ListStatus.initial) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          if (state.status == ListStatus.failure) {
            return Text('⚠ Gagal memuat COB',
                style: bodyTextStyle(context).copyWith(color: Colors.red));
          }
          if (state.items.isEmpty) {
            return Text('Tidak ada COB.',
                style: bodyTextStyle(context).copyWith(color: hintGrey));
          }

          final selected = state.items.where((c) => c.isChecked).toList();
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selected
                .map((c) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(cardBorderRadius),
              ),
              child: Text(
                c.cobNama,
                style: bodyTextStyle(context, fontSize: 12)
                    .copyWith(color: Colors.white),
              ),
            ))
                .toList(),
          );
        },
      ),
    );
  }
}

class _GhostIconButtonWithLabel extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Color bg;
  final String label;

  const _GhostIconButtonWithLabel({
    required this.onPressed,
    required this.icon,
    required this.bg,
    required this.label,
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
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
        child: Padding(padding: const EdgeInsets.all(8), child: icon),
      ),
    );
  }
}

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
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardBorderRadius)),
      ),
    );
  }
}