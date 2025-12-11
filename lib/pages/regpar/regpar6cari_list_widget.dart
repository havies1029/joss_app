import 'package:joss_app/blocs/regpar/regpar6form_bloc.dart';
import 'package:joss_app/blocs/regpar/regpar_upload_foto_object_bloc.dart';
import 'package:joss_app/pages/regpar/regpar_upload_foto_object_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/regpar/regpar6cari_bloc.dart';
import 'package:joss_app/pages/regpar/regpar6cari_tile_widget.dart';

class Regpar6CariListWidget extends StatefulWidget {
	final String regpar1Id;
	const Regpar6CariListWidget({super.key, required this.regpar1Id});

	@override
	Regpar6CariListWidgetState createState() => Regpar6CariListWidgetState();
}

class Regpar6CariListWidgetState extends State<Regpar6CariListWidget> {
	late Regpar6CariBloc regpar6CariBloc;
	final ScrollController _scrollController = ScrollController();

	@override
	void initState() {
		super.initState();
		_scrollController.addListener(_onScroll);
    Future.delayed(const Duration(milliseconds: 500), () {
			refreshData();
		});
	}

	@override
	void dispose() {
		_scrollController
			..removeListener(_onScroll)
			..dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		regpar6CariBloc = BlocProvider.of<Regpar6CariBloc>(context);
		return MultiBlocListener(
          listeners: [
            BlocListener<Regpar6FormBloc, Regpar6FormState>(
              listener: (context, state) {
                if (state.isSaved) {
                  refreshData();
                }
              },
            ),

            BlocListener<RegparUploadFotoObjectBloc, RegparUploadFotoObjectState>(
               listener: (context, state) {
                  if (state is UploadFotoObjectSuccess) {
                    refreshData();
                  }
               },
            ),
          ],
          child: BlocConsumer<Regpar6CariBloc, Regpar6CariState>(
            builder: (context, state) {
          if (state.status == ListStatus.success) {
          
          return Column(
            children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => RegparUploadFotoObjectDialog(regpar1Id: widget.regpar1Id),
                          );
                        },
                        child: const Text(
                          'Upload',
                          style: TextStyle(fontSize: 13.0),
                        ),
                      ),
                    ),
                  ),   
              Expanded(
                    child: state.items.isNotEmpty
                      ? ListView.builder(
                        padding: EdgeInsets.zero,
                        controller: _scrollController,
                        itemCount: state.items.length,
                        itemBuilder: (_, index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          padding: const EdgeInsets.all(0.2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0)),
                          child: Regpar6CariTileWidget(
                            fotoCaption: state.items[index].fotoCaption,
                            regpar6Id: state.items[index].regpar6Id, 
                                                    regpar1Id: widget.regpar1Id,
                          ),
                        ))
                      : const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 80.0),
                          child: Text(
                            'No Data Available!!',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ),
            ],
          );
          } else {
            return const Center(
                child: Text(
                  'No Data Available!!',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
                ),
              );
            }
            }, buildWhen: (previous, current) {
              return (current.status == ListStatus.success);
            }, listener: (context, state) {}
          ),
        );
	}
	void _onScroll() {
		if (!_scrollController.hasClients) return;
		if (_scrollController.position.pixels ==
				_scrollController.position.maxScrollExtent) {
			regpar6CariBloc.add(FetchRegpar6CariEvent());
		}
	}

  void refreshData() {
    regpar6CariBloc.add(Regpar6CariResetEvent());
		regpar6CariBloc.add(
			RefreshRegpar6CariEvent(regpar1Id: widget.regpar1Id));
	}

}
