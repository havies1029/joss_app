import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/gen_klaim/mobile/widget/list_klaim_widget/timeline_card_widget.dart';
import 'package:joss_app/widgets/apptheme/header_card.dart';
import '../../../../../blocs/gen_klaim/klaim1crud_bloc.dart';
import '../../../../../blocs/gen_klaim/klaim1list_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../base/base_background_sidepage.dart';
import 'list_card_klaim_widget.dart';

class ListKlaimWidget extends StatefulWidget {
  const ListKlaimWidget({super.key});

  @override
  _ListKlaimWidgetState createState() => _ListKlaimWidgetState();
}

class _ListKlaimWidgetState extends State<ListKlaimWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _scrollCtr = ScrollController();
  bool _showAddForm = false;
  bool _isSavingNew = false;
  final Map<String, bool> _isSavingById = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: defaultDuration,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Klaim1ListBloc>().add(FetchKlaim1ListEvent());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          title: 'Klaim',
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HeaderCard(
                  iconPath: "assets/icons/menu_klaim.svg",
                  title: "Klaim",
                  subtitle:
                  "Ajukan klaim Anda dengan mudah dan cepat sesuai ketentuan polis yang berlaku.",
                ),
                ListCardKlaimWidget(
                  isSavingById: _isSavingById,
                  onSaveExisting: (id, record) {
                    setState(() => _isSavingById[id] = true);
                    context
                        .read<Klaim1CrudBloc>()
                        .add(Klaim1CrudUbahEvent(record: record));
                  },
                  onDelete: (id) {
                    context
                        .read<Klaim1CrudBloc>()
                        .add(Klaim1CrudHapusEvent(recordId: id));
                  },
                  onView: (record) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TimelineCardWidget(record: record),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
