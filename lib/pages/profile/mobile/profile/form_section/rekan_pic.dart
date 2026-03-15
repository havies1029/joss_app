import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:joss_app/blocs/gen_profile/mrekanpiclist_bloc.dart';
import 'package:joss_app/blocs/gen_profile/mrekanpiccrud_bloc.dart';

import '../../../../../blocs/gen_invite/invite_bloc.dart';
import '../../../../../blocs/gen_profile/rekanpiccobcari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../models/gen_profile/mrekanpiclist_model.dart';
import '../../../../../repositories/gen_invite/invite_repository.dart';
import '../../../../../widgets/apptheme/invite_success_popup.dart';
import '../../../../../widgets/showdialoghapus_widget.dart';
import '../../../../base/base_background_sidepage.dart';
import 'crud_pic/edit_pic_remake.dart';
import 'crud_pic/tambah_pic_remake.dart';

class MrekanPicMainPage extends StatefulWidget {
  const MrekanPicMainPage({super.key});

  @override
  State<MrekanPicMainPage> createState() => _MrekanPicMainPageState();
}

class _MrekanPicMainPageState extends State<MrekanPicMainPage> {
  late MRekanPicListBloc listBloc;
  late MRekanPicCrudBloc crudBloc;

  @override
  void initState() {
    super.initState();
    listBloc = context.read<MRekanPicListBloc>();
    crudBloc = context.read<MRekanPicCrudBloc>();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  void loadData() {
    listBloc.add(
        FetchMRekanPicListEvent());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return BaseBackgroundSidePage(
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
                  vertical: 10,
                ),

                child: MultiBlocListener(
                  listeners: [

                    BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
                      listenWhen: (prev, curr) => prev.isSaved != curr.isSaved,
                      listener: (context, state) {
                        if (state.isSaved) {
                          context.read<MRekanPicListBloc>().add(FetchMRekanPicListEvent());
                        }
                      },
                    ),
                  ],

                  // UI tetap pakai BlocBuilder LIST
                  child: BlocBuilder<MRekanPicListBloc, MRekanPicListState>(
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
                            Text('Gagal memuat data PIC', style: bodyTextStyle(context)),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () =>
                                  context.read<MRekanPicListBloc>().add(FetchMRekanPicListEvent()),
                              child: const Text('Coba lagi'),
                            ),
                          ],
                        );
                      }

                      final total = state.items.length;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Total PIC: $total',
                                style: bodyTextStyle(context, fontSize: 16),
                              ),
                              const Spacer(),
                              SizedBox(width: 120, height:30,child: AppButton.iconLeft(
                                text: 'Tambah PIC',
                                textStyle: bodyTextStyle(context, fontSize: 16),
                                icon: const Icon(Icons.add, size: 16),
                                onPressed: () async {
                                  final changed = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(builder: (_) => const TambahPicWidget()),
                                  );

                                  if (changed == true) {
                                    context.read<MRekanPicListBloc>().add(
                                      FetchMRekanPicListEvent(),
                                    );
                                  }
                                },
                              ))
                            ],
                          ),

                          const SizedBox(height: 12),

                          if (state.items.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Belum ada PIC.',
                                style: bodyTextStyle(context, fontSize: 16),
                              ),
                            )
                          else
                            Column(
                              children: List.generate(state.items.length, (i) {
                                final it = state.items[i];
                                final id = (it.mrekanpicId ?? '').trim();
                                if (id.isEmpty) return const SizedBox.shrink();

                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: i == state.items.length - 1 ? 0 : 14,
                                  ),
                                  child: _picCardFromItem(it, i),
                                );
                              }),
                            ),
                        ],
                      );
                    },
                  ),
                ),

              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _goEditById(String id) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditPicWidget(mrekanpicId: id),
      ),
    );

    if (changed == true) {
      context.read<MRekanPicListBloc>().add(
        FetchMRekanPicListEvent(),
      );
    }
  }

  Widget _picCardFromItem(MRekanPicListModel it, int index) {
    final id = (it.mrekanpicId ?? '').trim();

    final labelStyle =
    bodyTextStyle(context, fontSize: 16).copyWith(color: cardGrey);
    final valueStyle =
    bodyTextStyle(context, fontSize: 16).copyWith(color: primaryLightColor);

    return Card(
      color: formGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        side: const BorderSide(color: sGrey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppButton.icon(
                  icon: SvgPicture.asset(
                    'assets/icons/edit_icon_polis.svg',
                    width: 15,
                    height: 15,
                  ),
                  onPressed: () => _goEditById(id),
                  backgroundColor: const Color(0xFFFFC20A),
                  squareSize: 30,
                  borderRadius: 8,
                ),
                const SizedBox(width: 6),
                AppButton.icon(
                  icon: SvgPicture.asset(
                    'assets/icons/hapus.svg',
                    width: 15,
                    height: 15,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () => _confirmDelete(id),
                  backgroundColor: const Color(0xFFF63434),
                  squareSize: 30,
                  borderRadius: 8,
                ),

                const Spacer(),

                if ((it.statusPic ?? '').toLowerCase() != 'sudah aksep')
                  _inviteButton(
                    mrekanpicId: it.mrekanpicId,
                    nama: it.picNama,
                    email: it.picEmail,
                  ),
              ],
            ),

            const SizedBox(height: 8),
            Divider(color: sGrey),
            const SizedBox(height: 8),

            _cardRow('Email:', it.picEmail, labelStyle, valueStyle),
            _cardRow('Nama:', it.picNama, labelStyle, valueStyle),
            _cardRow('No Telp:', it.picHp, labelStyle, valueStyle),
            // _cardRow('Jabatan:', it.jabatanDesc, labelStyle, valueStyle),
            // _cardRow('Peran:', it.peranan, labelStyle, valueStyle),
            // _cardRow('Status:', it.statusPic, labelStyle, valueStyle),

            const SizedBox(height: 8),
            Divider(color: sGrey),
            const SizedBox(height: 8),

            Text(
              'Polis yang bisa diakses:',
              style: bodyTextStyle(context, fontSize: 16),
            ),
            const SizedBox(height: 6),

            _cobListSection(rekanPicId: id),
          ],
        ),
      ),
    );
  }

  Widget _cardRow(String label, String value, TextStyle labelStyle, TextStyle valueStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(text: '$label ', style: labelStyle),
          TextSpan(text: value, style: valueStyle),
        ]),
      ),
    );
  }

  Widget _cobListSection({required String rekanPicId}) {
    return BlocProvider(
      create: (_) => RekanPicCobCariBloc()
        ..add(
          RefreshRekanPicCobCariEvent(
            rekanPicId: rekanPicId,
            searchText: '',
          ),
        ),
      child: BlocBuilder<RekanPicCobCariBloc, RekanPicCobCariState>(
        builder: (context, state) {
          if (state.status == ListStatus.initial) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          if (state.status == ListStatus.failure) {
            return Text(
              'Gagal memuat COB',
              style: bodyTextStyle(context).copyWith(color: Colors.red),
            );
          }
          if (state.items.isEmpty) {
            return Text(
              'Tidak ada COB.',
              style: bodyTextStyle(context).copyWith(color: hintGrey),
            );
          }

          final selected = state.items.where((c) => c.isChecked).toList();

          return Wrap(
            spacing: 6,
            runSpacing: 6,
            children: selected
                .map(
                  (c) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  c.cobNama,
                  style: bodyTextStyle(context, fontSize: 12),
                ),
              ),
            )
                .toList(),
          );
        },
      ),
    );
  }

  Widget _inviteButton({
    required String mrekanpicId,
    required String nama,
    required String email,
  }) {
    return BlocProvider(
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

          return _ghostIconButtonWithLabel(
            label: isLoading ? 'Mengirim...' : 'Kirim Undangan',
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
              
              context.read<InviteBloc>().add(
                SendInviteEvent(
                  mrekanpicId: mrekanpicId,
                  nama: nama,
                  email: email,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(String recordId) {
    final id = recordId.trim();
    if (id.isEmpty) return;
    listBloc = context.read<MRekanPicListBloc>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ShowDialogHapusWidget(
        recordId: id,
        onHapusFunction: (deleteId) {
          context.read<MRekanPicCrudBloc>().add(
            MRekanPicCrudHapusEvent(recordId: deleteId),
          );
        },
      ),
    ).then((_) {
      listBloc.add(FetchMRekanPicListEvent());
    });
  }



  Widget _ghostIconButtonWithLabel({
    required VoidCallback? onPressed,
    required Widget icon,
    required Color bg,
    required String label,
  }) {
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

  Widget _ghostIconButton({
    required VoidCallback? onPressed,
    required Widget icon,
    required Color bg,
  }) {
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

