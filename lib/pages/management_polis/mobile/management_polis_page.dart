import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../../../common/constants.dart';
import '../../../blocs/gen_sppamv/sppa_download_polis_bloc.dart';
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
        BlocListener<SppaDownloadPolisBloc, SppaDownloadPolisState>(

          listener: (context, state) {
            if (state is DownloadSuccess) {
              debugPrint("SppaDownloadPolisBloc: sucess");
              OpenFilex.open(state.filePath);
            } else if (state is DownloadFailure) {
              final message = state.message;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Download failed: $message')),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: primaryBlackColor,
        body: SafeArea(
          child: Stack(
            children: [
              BaseBackgroundSidePage(
                title: 'Polis',
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        HeaderCard(
                          iconPath: "assets/icons/menu_polis.svg",
                          title: "Polis",
                          subtitle:
                          "Kelola dan pantau semua polis Anda dalam satu aplikasi.",
                        ),
                        ManagementPolisFilter(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: const FloatingMenuWrapper(),
      ),
    );
  }


}


