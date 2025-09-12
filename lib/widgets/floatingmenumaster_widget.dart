import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloatingMenuMasterWidget extends StatefulWidget {
  final Function onTambah;

  const FloatingMenuMasterWidget(
      {super.key,
      required this.onTambah});

  @override
  FloatingMenuMasterWidgetState createState() =>
      FloatingMenuMasterWidgetState();
}

class FloatingMenuMasterWidgetState extends State<FloatingMenuMasterWidget> {
  @override
  Widget build(BuildContext context) {
    var renderOverlay = true;
    var visible = true;
    var switchLabelPosition = false;
    var mini = false;
    var closeManually = false;
    var useRAnimation = true;
    var isDialOpen = ValueNotifier<bool>(false);
    var speedDialDirection = SpeedDialDirection.up;
    var buttonSize = const Size(56.0, 56.0);
    var childrenButtonSize = const Size(56.0, 56.0);

    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      mini: mini,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      buttonSize:
          buttonSize, // it's the SpeedDial size which defaults to 56 itself
      childrenButtonSize: childrenButtonSize,
      visible: visible,
      direction: speedDialDirection,
      switchLabelPosition: switchLabelPosition,
      closeManually: closeManually,
      renderOverlay: renderOverlay,
      onOpen: () => debugPrint('OPENING DIAL'),
      onClose: () => debugPrint('DIAL CLOSED'),
      useRotationAnimation: useRAnimation,
      tooltip: 'Open Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      elevation: 8.0,
      animationCurve: Curves.elasticInOut,
      isOpenOnStart: false,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.add),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Add',
            onTap: () {
              widget.onTambah();
            }),
      ],
    );
  }
}
