import 'package:joss_app/blocs/klaimrinci/groupcobcari_bloc.dart';
import 'package:joss_app/blocs/klaimrinci/mstatusrincicari_bloc.dart';
import 'package:joss_app/pages/klaimrinci/groupcobcari_list.dart';
import 'package:joss_app/pages/klaimrinci/mstatusrincicari_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KlaimRinciCariMainPage extends StatefulWidget {
  const  KlaimRinciCariMainPage({super.key});

  @override
  KlaimRinciCariMainPageState createState() => KlaimRinciCariMainPageState();
}

class KlaimRinciCariMainPageState extends State<KlaimRinciCariMainPage> {

	@override
	Widget build(BuildContext context) {
		return MultiBlocListener(
      listeners: [
        BlocListener<MstatusrinciCariBloc, MstatusrinciCariState>(
            listener: (context, state) {
              context.read<GroupcobCariBloc>().add(
                RefreshGroupcobCariEvent(
                  statusId: state.selectedStatusId, searchText: state.searchText,
                ),
              );
            }, listenWhen: (previous, current) {
          return ((previous.selectedStatusId != current.selectedStatusId) ||
              (previous.searchText != current.searchText));
        }),

      ],
      child: Column(

        children: [
          SizedBox(
            height: 152,
            child: MstatusrinciCariPage(),
          ),

          const SizedBox(height: 8),
          Expanded(child: const GroupcobCariPage())
        ],
      ),
    );
	}
}
