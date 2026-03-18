import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../../../common/constants.dart';
import '../../../blocs/gen_cob_app/cobmanpol_bloc.dart';
import '../../../blocs/gen_sppamv/sppa_download_polis_bloc.dart';
import '../../../common/loading_indicator.dart';
import '../../../widgets/apptheme/empty_state_page.dart';
import '../../../widgets/apptheme/header_card.dart';
import '../../base/base_background_sidepage.dart';
import '../floating_menu_wrapper.dart';
import 'management_polis_filter.dart';

class ManagementPolisPage extends StatefulWidget {
  const ManagementPolisPage({super.key});

  @override
  _ManagementPolisPageState createState() => _ManagementPolisPageState();
}

class _ManagementPolisPageState extends State<ManagementPolisPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final _formKey = GlobalKey<FormState>();
  bool hasData = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: defaultDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CobManPolBloc, CobManPolState>(
          listener: (context, state) {
            if (state.status == ListStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gagal memuat data polis'),
                ),
              );
            }

            if (state.status == ListStatus.success) {
              setState(() {
                hasData = state.items.isNotEmpty;
              });
            }
          },
        ),
      ],
      child: BlocConsumer<SppaDownloadPolisBloc, SppaDownloadPolisState>(
        listener: (context, state) {
          if (state is DownloadSuccess) {
            OpenFilex.open(state.filePath);
          } else if (state is DownloadFailure) {
            final message = state.message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Download failed: $message')),
            );
          }
        },
        builder: (context, state) {
          final isDownloading = state is DownloadLoading;

          return Stack(
            children: [
              Scaffold(
                backgroundColor: secondaryBlackColor,
                body: SafeArea(
                  child: Stack(
                    children: [
                      BaseBackgroundSidePage(
                        title: 'Polis',
                        child: Form(
                          key: _formKey,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: IntrinsicHeight(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .stretch,
                                      children: [
                                        HeaderCard(
                                          iconPath: "assets/icons/menu_polis.svg",
                                          title: "Polis",
                                          subtitle:
                                          "Kelola dan pantau semua polis Anda dalam satu aplikasi.",
                                        ),
                                        hasData
                                            ? const ManagementPolisFilter()
                                            : const Expanded(
                                          child: Center(
                                            child: _EmptyPolisView(),
                                          ),
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
                    ],
                  ),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation
                    .endFloat,
                floatingActionButton: const FloatingMenuWrapper(),
              ),

              if (isDownloading)
                Positioned.fill(
                  child: AbsorbPointer(
                    absorbing: true,
                    child: Container(
                      color: Colors.black45,
                      alignment: Alignment.center,
                      child: LoadingIndicator(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}


class _EmptyPolisView extends StatelessWidget {
  const _EmptyPolisView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: secondaryBlackColor,
      child: Center(
        child: EmptyStatePage(iconPath: 'assets/icons/belipolis_no_file.svg',title: 'Tidak ada polis',description: 'Anda belum memiliki polis. Cari dan beli asuransi untuk mulai melindungi diri Anda',) ,
      ),
    );
  }
}

