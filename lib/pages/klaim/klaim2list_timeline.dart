import 'dart:developer';

import 'package:joss_app/widgets/my_colors.dart';
import 'package:joss_app/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/klaim/klaim2list_bloc.dart';

class Klaim2ListTimeline extends StatefulWidget {
  final String klaim1Id;
  const Klaim2ListTimeline({super.key, required this.klaim1Id});

  @override
  Klaim2ListTimelineState createState() => Klaim2ListTimelineState();
}

class Klaim2ListTimelineState extends State<Klaim2ListTimeline> {
  late Klaim2ListBloc klaim2ListBloc;
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
    klaim2ListBloc = BlocProvider.of<Klaim2ListBloc>(context);
    return BlocConsumer<Klaim2ListBloc, Klaim2ListState>(
        builder: (context, state) {
          if (state.status == ListStatus.success) {
            return state.items.isNotEmpty
                ? Timeline.tileBuilder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    theme: TimelineThemeData(
                      nodePosition: 0,
                      color: const Color.fromARGB(255, 152, 152, 152),
                      indicatorTheme: const IndicatorThemeData(
                        position: 0,
                        size: 20.0,
                      ),
                      connectorTheme: const ConnectorThemeData(
                        thickness: 2.5,
                      ),
                    ),
                    builder: TimelineTileBuilder.connected(
                      connectionDirection: ConnectionDirection.before,
                      indicatorBuilder: (_, index) {
                        if (state.items[index].hasDone) {
                          return const DotIndicator(
                            color: Color(0xff66c97f),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12.0,
                            ),
                          );
                        } else {
                          return const OutlinedDotIndicator(
                            borderWidth: 2.5,
                          );
                        }
                      },
                      connectorBuilder: (_, index, ___) => SolidLineConnector(
                        color: (state.items[index].hasDone)
                            ? const Color(0xff66c97f)
                            : null,
                      ),
                      contentsAlign: ContentsAlign.basic,
                      contentsBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [                                          
                                          Visibility(
                                            visible: state.items[index].hasDone,
                                            child: Text(
                                            DateFormat('dd/MM/yyyy')
                                                .format(state.items[index]
                                                    .perubahanTgl),
                                            style: MyText.titleLarge(
                                                    context)!
                                                .copyWith(
                                                    color:
                                                        MyColors.grey_95))),                                          
                                          Container(height: 15),
                                          Text(
                                              'Status : ${state.items[index].statusNama}',
                                              style: MyText.bodyLarge(context)!
                                                  .copyWith(
                                                      color: MyColors.grey_80)),
                                          Container(height: 10),
                                          Visibility(
                                            visible: state.items[index].hasDone,
                                            child: buildColumnKeterangan(state.items[index].keterangan)),
                                          //state.items[index].hasDone ? buildColumnKeterangan(state.items[index].keterangan) : Container(),                                          
                                          Container(height: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      itemCount: state.items.length,
                    ),
                  )
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
        },
        buildWhen: (previous, current) {
          return (current.status == ListStatus.success);
        },
        listener: (context, state) {});
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      klaim2ListBloc.add(FetchKlaim2ListEvent());
    }
  }

  void refreshData() {
    klaim2ListBloc.add(RefreshKlaim2ListEvent(klaim1Id: widget.klaim1Id));
  }

  Widget buildColumnKeterangan(String keterangan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Keterangan",
            style:
                MyText.bodyLarge(context)!.copyWith(color: MyColors.grey_40)),
        Container(height: 5),
        Text(keterangan,
            style:
                MyText.bodyLarge(context)!.copyWith(color: MyColors.grey_80)),
        Container(height: 10),
      ],
    );
  }
}
