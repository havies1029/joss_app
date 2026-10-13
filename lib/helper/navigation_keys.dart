import 'package:flutter/material.dart';

import '../pages/home/home_tab_widget.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showRootSnackBar(SnackBar snackBar) {
  final messenger = rootScaffoldMessengerKey.currentState;
  if (messenger == null) return;

  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(snackBar);
}

final GlobalKey<HomeTabWidgetState> homeTabKey =
    GlobalKey<HomeTabWidgetState>();
