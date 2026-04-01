import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../blocs/gen_invite/invite_bloc.dart';
import '../../../../../blocs/gen_profile/mrekanpiccrud_bloc.dart';
import '../../../../../blocs/gen_profile/mrekanpiclist_bloc.dart';
import '../../../../../blocs/gen_profile/rekanpiccobcari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../models/gen_profile/mrekanpiclist_model.dart';
import '../../../../../repositories/gen_invite/invite_repository.dart';
import '../../../../../widgets/apptheme/empty_state_page.dart';
import '../../../../../widgets/apptheme/invite_success_popup.dart';
import '../../../../../widgets/showdialoghapus_widget.dart';
import '../../../../base/base_background_sidepage.dart';
import 'crud_pic/edit_pic_widget.dart';
import 'crud_pic/tambah_pic_widget.dart';

class RekanPicWidgetPage extends StatefulWidget {
  const RekanPicWidgetPage({super.key});

  @override
  State<RekanPicWidgetPage> createState() => _RekanPicWidgetPageState();
}


class _RekanPicWidgetPageState extends State<RekanPicWidgetPage> {
  late MRekanPicListBloc listBloc;

  @override
  void initState() {
    super.initState();
    listBloc = context.read<MRekanPicListBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      listBloc.add(FetchMRekanPicListEvent());
    });
  }

  String _displayStatus(String? status) {
    final normalized = _normalizedStatus(status);

    if (normalized == 'belum kirim' || normalized == 'belum aksep') {
      return 'Belum aktif';
    }

    if (normalized == 'sudah aksep') {
      return 'Aktif';
    }

    if (normalized == 'tidak aktif') {
      return 'Tidak Aktif';
    }

    return status?.trim().isNotEmpty == true ? status!.trim() : '-';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<MRekanPicCrudBloc, MRekanPicCrudState>(
          listenWhen: (previous, current) {
            return previous.isSaving != current.isSaving ||
                previous.isSaved != current.isSaved ||
                previous.hasFailure != current.hasFailure;
          },
          listener: (context, state) {
            if (!state.isSaving && state.isSaved && !state.hasFailure) {
              context.read<MRekanPicListBloc>().add(
                RefreshMRekanPicListEvent(),
              );
            }

            if (!state.isSaving && state.isSaved && state.hasFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gagal menghapus PIC'),
                ),
              );
            }
          },
        ),
      ],
      child: BaseBackgroundSidePage(
        title: 'Informasi PIC',
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: double.infinity,
              color: secondaryBlackColor,
              padding: EdgeInsets.symmetric(
                horizontal: hPadding * 1.5,
                vertical: 10,
              ),
              child: BlocBuilder<MRekanPicListBloc, MRekanPicListState>(
                builder: (context, state) {
                  if (state.status == ListStatus.initial) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: LoadingIndicator(),
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
                          onPressed: () => context
                              .read<MRekanPicListBloc>()
                              .add(RefreshMRekanPicListEvent()),
                          child: const Text('Coba lagi'),
                        ),
                      ],
                    );
                  }

                  final total = state.items.length;

                  Widget header() {
                    return Row(
                      children: [
                        Text(
                          'Total PIC: $total',
                          style: bodyTextStyle(context, fontSize: 16),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 120,
                          height: 30,
                          child: AppButton.iconLeft(
                            text: 'Tambah PIC',
                            textStyle: bodyTextStyle(context, fontSize: 16),
                            icon: const Icon(Icons.add, size: 16),
                            onPressed: () {
                              Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TambahPicWidget(),
                                ),
                              );
                              context.read<RekanPicCobCariBloc>().add(
                                const ResetSelectedCOBRekanPicCobEvent(),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  if (state.items.isEmpty) {
                    return SizedBox(
                      height: constraints.maxHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          header(),
                          const SizedBox(height: hPadding),
                          const Expanded(
                            child: Center(
                              child: EmptyStatePage(
                                iconPath: 'assets/icons/logo_pic.svg',
                                title: 'Tidak ada Informasi PIC',
                                description:
                                'Silakan tambahkan PIC terlebih dahulu agar informasi PIC dapat ditampilkan.',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          header(),
                          const SizedBox(height: 12),
                          Column(
                            children: List.generate(state.items.length, (i) {
                              final it = state.items[i];
                              final id = it.mrekanpicId.trim();

                              if (id.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: i == state.items.length - 1 ? 0 : 14,
                                ),
                                child: _picCardFromItem(it, i),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _picCardFromItem(MRekanPicListModel it, int index) {
    final id = it.mrekanpicId.trim();
    final isTidakAktif = _normalizedStatus(it.statusPic) == 'tidak aktif';
    final isDefault = it.isDefault;

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
                if (!isTidakAktif) ...[
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
                  if (!isDefault) ...[
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
                  ],
                ],
                const Spacer(),
                if (!isTidakAktif) _buildPicStatusAction(it),
              ],
            ),

            if (!isTidakAktif) ...[
              const SizedBox(height: 8),
              Divider(color: sGrey),
              const SizedBox(height: 8),
            ],

            _cardRow(
              'PIC:',
              '${index + 1}',
              labelStyle,
              valueStyle,
            ),
            _cardRow(
              'Email:',
              it.picEmail.isEmpty ? '-' : it.picEmail,
              labelStyle,
              valueStyle,
            ),
            _cardRow(
              'Nama:',
              it.picNama.isEmpty ? '-' : it.picNama,
              labelStyle,
              valueStyle,
            ),
            _cardRow(
              'Alamat:',
              it.alamat1.isEmpty ? '-' : it.alamat1,
              labelStyle,
              valueStyle,
            ),
            _cardRow(
              'No Telp:',
              it.picHp.isEmpty ? '-' : it.picHp,
              labelStyle,
              valueStyle,
            ),
            _cardRow(
              'Jabatan:',
              it.jabatanNama.isEmpty ? '-' : it.jabatanNama,
              labelStyle,
              valueStyle,
            ),
            _cardRow(
              'Status:',
              _displayStatus(it.statusPic),
              labelStyle,
              valueStyle,
            ),
            const SizedBox(height: 8),
            Divider(color: sGrey),
            const SizedBox(height: 8),
            Text(
              'Polis yang bisa diakses:',
              style: bodyTextStyle(
                context,
                fontSize: getResponsiveFont(context, 16),
              ),
            ),
            const SizedBox(height: 6),
            _cobListSection(cobItems: _parseCobItems(it.listCob)),
          ],
        ),
      ),
    );
  }

  List<String> _parseCobItems(String listCob) {
    return listCob
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
  Widget _cobListSection({required List<String> cobItems}) {
    if (cobItems.isEmpty) {
      return Text(
        'Tidak ada COB.',
        style: bodyTextStyle(context).copyWith(color: hintGrey),
      );
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: cobItems.map((cob) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            cob,
            style: bodyTextStyle(context, fontSize: 12),
          ),
        );
      }).toList(),
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

  Future<void> _goEditById(String id) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditPicWidget(mrekanpicId: id),
      ),
    );

    context.read<RekanPicCobCariBloc>().add(
      const ResetSelectedCOBRekanPicCobEvent(),
    );
    // if (changed == true) {
    //   context.read<MRekanPicListBloc>().add(
    //     FetchMRekanPicListEvent(),
    //   );
    // }
  }



  Future<void> _confirmDelete(String recordId) async {
    final id = recordId.trim();
    if (id.isEmpty) return;

    await showDialog<bool>(
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
    );
  }

  String _normalizedStatus(String? status) {
    return (status ?? '').trim().toLowerCase();
  }

  Widget _buildPicStatusAction(MRekanPicListModel it) {
    final status = _normalizedStatus(it.statusPic);

    if (status == 'belum kirim') {
      return _inviteButton(
        parentContext: context,
        mrekanpicId: it.mrekanpicId,
        nama: it.picNama,
        email: it.picEmail,
      );
    }

    if (status == 'belum aksep') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/iconamoon_check-light.svg',
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              sGreen,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Undangan Dikirim',
            style: bodyTextStyle(context, fontSize: 16).copyWith(
              color: sGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    if (status == 'sudah aksep') {
      return const SizedBox.shrink();
    }

    if (status == 'tidak aktif') {
      return const SizedBox.shrink();
    }

    return const SizedBox.shrink();
  }

  Widget _inviteButton({
    required BuildContext parentContext,
    required String mrekanpicId,
    required String nama,
    required String email,
  }) {
    return BlocProvider(
      create: (_) => InviteBloc(repo: InviteRepository()),
      child: BlocConsumer<InviteBloc, InviteState>(
        listener: (context, state) async {
          if (state.isSuccess) {
            parentContext.read<MRekanPicListBloc>().add(
              RefreshMRekanPicListEvent(),
            );

            await showDialog(
              context: parentContext,
              builder: (_) => const InviteSuccessPopup(),
            );
          } else if (state.message.isNotEmpty && !state.isLoading) {
            ScaffoldMessenger.of(parentContext).showSnackBar(
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
}