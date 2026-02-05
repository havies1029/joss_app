import 'package:flutter/foundation.dart';
import 'package:joss_app/pages/management_polis/floating_action_menu_widget.dart';

@immutable
class FabMenuState {
  final String cobId;
  final String statusId;
  final Object? selectedItem;
  final List<ActionMenuItem> actions;

  const FabMenuState({
    required this.cobId,
    required this.statusId,
    required this.selectedItem,
    required this.actions,
  });

  List<Object> get selectedItems =>
      selectedItem == null ? const <Object>[] : <Object>[selectedItem!];
}
